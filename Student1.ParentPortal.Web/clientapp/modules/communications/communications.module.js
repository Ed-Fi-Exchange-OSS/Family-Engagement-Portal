angular.module('app')
    .config(['$stateProvider', function($stateProvider) {
        $stateProvider.state('app.communications', {
            url: '/communications/:?studentUsi/:&recipientUniqueId/:&recipientTypeId/&:{unreadData:json}',
            requireADLogin: true,
            views: {
                'content@': { component:'communications' }
            },
            resolve: {
                studentUsi: ['$stateParams', function ($stateParams) {
                    return $stateParams.studentUsi;
                }],
                sender: ['api', function (api) { return api.me.getMyBriefProfile(); }],
                recipients: ['$stateParams', 'api', function ($stateParams, api) {
                    return api.communications.allRecipients({ studentUsi: $stateParams.studentUsi, rowsToSkip: 0, rowsToRetrieve: 10 });
                }],
                chatModel: ['$stateParams', 'api', function ($stateParams, api) {
                    if (!$stateParams.recipientUniqueId || !$stateParams.recipientTypeId || !$stateParams.studentUsi)
                        return null;

                    var request = { studentUsi: $stateParams.studentUsi, recipientUniqueId: $stateParams.recipientUniqueId, recipientTypeId: $stateParams.recipientTypeId, unreadMessageCount: $stateParams.unreadMessageCount };
                    return api.communications.getChatThread(request).then(function (chatModel) {
                        return chatModel;
                    });
                }],
                languages: ['api', function (api) { return api.translate.getAvailableLanguages(); }],
                }
            });
    }])
    .component('communications', {
        bindings: {
            student: "<",
            sender: "<",
            recipients: "<",
            model: "<",
            languages: "<",
            chatModel: "<",
            studentUsi : "<",
        }, // One way data binding.
        templateUrl: 'clientapp/modules/communications/communications.view.html',
        controllerAs:'ctrl',
        controller: ['api', '$translate', '$timeout', '$rootScope', 'landingRouteService', 'signalRService', '$location', function (api, $translate, $timeout, $rootScope, landingRouteService, signalRService, $location) {

            var ctrl = this;
            ctrl.urls = [];
            ctrl.simultaneousTranslation = false;
            ctrl.recipientsLoading = false;
            ctrl.filteredRecipients = [];
            ctrl.searchValue = '';
            ctrl.simultaneousTranslationDone = false;

            // Get the Url for the breadcrumb
            landingRouteService.getRoute().then(function (route) {
                ctrl.urls.push({ displayName: 'Home', url: route });
            });

            // SignalR hub
            var chatHub = signalRService.init('ChatHub');

            chatHub.on('messageReceived', function (message) {
                var model = JSON.parse(message);
                // Only add message if the message is for the current user.
                if ($location.url().includes('communications'))
                {
                    ctrl.chatModel.conversation.messages.push(model);
                    // Update that message was read while online
                    if (ctrl.sender.uniqueId === model.recipientUniqueId && ctrl.sender.personTypeId === model.recipientTypeId) {
                        model.read = true;
                        api.communications.recipientRead(model);
                    }
                    
                    ctrl.scrollToEndOfChat();
                }
            });

            chatHub.start();

            // Scroll to end of chat...
            ctrl.scrollToEndOfChat = function () {
                $timeout(function () {
                    var scroller = document.getElementById("message-history");
                    scroller.scrollTop = scroller.scrollHeight;
                }, 0, false);
            };

            ctrl.selectStudentRecipient = function (studentRecipient) {
                if (ctrl.model.selectedStudent && ctrl.model.selectedStudent.studentUsi == studentRecipient.studentUsi) {
                    ctrl.model.selectedStudent = null;
                    ctrl.model.selectedRecipient = null;
                }
                if (studentRecipient.recipients.length > 0)
                    studentRecipient.show = !studentRecipient.show;
                else
                    toastr.error($translate.instant('Student with no Parents') + ".");
            };
            // Select the Recipient
            ctrl.selectRecipient = function (recipient, student) {

                ctrl.model.selectedStudent = student;
                ctrl.model.selectedRecipient = recipient;

                // API call get latest 15 messages.
                var request = { studentUsi: ctrl.model.selectedStudent.studentUsi, recipientUniqueId: recipient.uniqueId, recipientTypeId: recipient.personTypeId, rowsToSkip: 0, unreadMessageCount: ctrl.model.selectedRecipient.unreadMessageCount };

                api.communications.getChatThread(request).then(function (chatModel) {
                    ctrl.updateMessagesLanguage(chatModel.conversation.messages);
                    ctrl.chatModel = chatModel;
                    ctrl.model.selectedRecipient.unreadMessageCount = 0;

                    ctrl.scrollToEndOfChat();
                });
            };

            ctrl.loadMore = function () {
                // API call get another 15 messages.

                var request = { studentUsi: ctrl.model.selectedStudent.studentUsi , recipientUniqueId: ctrl.model.selectedRecipient.uniqueId, recipientTypeId: ctrl.model.selectedRecipient.personTypeId, rowsToSkip: ctrl.chatModel.conversation.messages.length };

                api.communications.getChatThread(request).then(function (chatModel) {
                    ctrl.updateMessagesLanguage(chatModel.conversation.messages);
                    ctrl.chatModel.conversation.endOfMessageHistory = chatModel.conversation.endOfMessageHistory;
                    ctrl.chatModel.conversation.messages.unshift(...chatModel.conversation.messages);
                });
            };

            // Send message
            ctrl.sendMessage = function () {
                if (!ctrl.model.message || ctrl.model.message.length == 0)
                    return;

                while (ctrl.simultaneousTranslation && !ctrl.simultaneousTranslationDone) {  /* waiting for translation to end */ };
                ctrl.simultaneousTranslationDone = false;

                // Call SignalR.
                var chatModel = {
                    studentUniqueId: ctrl.model.selectedStudent.studentUniqueId,
                    recipientUniqueId: ctrl.model.selectedRecipient.uniqueId,
                    recipientTypeId: ctrl.model.selectedRecipient.personTyId,
                    recipientTypeId: ctrl.model.selectedRecipient.personTypeId,
                    originalMessage: ctrl.model.message,
                    englishMessage: ctrl.simultaneousTranslation ? ctrl.model.englishMessage : null,
                };
                // Call API that will persist and call the SignalR Hub to update clients.
                api.communications.postMessage(chatModel).then(function (data) {
                    ctrl.model.message = '';
                    ctrl.model.englishMessage = '';
                    ctrl.chatModel.conversation.messages.push(data);
                    ctrl.scrollToEndOfChat();
                });
            };

            // Change Lang
            ctrl.onLanguageChange = function() {
                ctrl.updateMessagesLanguage(ctrl.chatModel.conversation.messages);
            };


            ctrl.updateMessagesLanguage = function (array) {
                array.forEach(function (m) {
                    api.translate
                        .autoDetectTranslate({ textToTranslate: m.originalMessage, toLangCode: ctrl.selectedLanguage.code })
                        .then(function (t) {
                            m.translated = t;
                        });
                });
            };

            // Do simultaneous translation
            ctrl.simulTran = function () {
                if (!ctrl.simultaneousTranslation)
                    return;

                if (ctrl.model.message.length > 2) {
                    $rootScope.loadingOverride = true;
                    api.translate.autoDetectTranslate({ textToTranslate: ctrl.model.message, toLangCode: 'en' })
                        .then(function (t) {
                            ctrl.model.englishMessage = t;
                            ctrl.simultaneousTranslationDone = true;
                            $rootScope.loadingOverride = false;
                        });
                }

            };

            ctrl.back = function () {
                ctrl.model.selectedRecipient = null;
            }

            ctrl.getAllRecipients = function () {
                $rootScope.loadingOverride = true;
                ctrl.recipientsLoading = true;
                api.communications.allRecipients({ rowsToSkip: ctrl.recipients.studentRecipients.length, rowsToRetrieve: 5 })
                    .then(function (result) {
                        if (!result.endOfData)
                            ctrl.getAllRecipients();
                        else {
                            $rootScope.loadingOverride = false;
                            ctrl.recipientsLoading = false;
                        }
                        var newList = ctrl.recipients.studentRecipients.concat(result.studentRecipients).slice(0);
                        ctrl.recipients.studentRecipients = newList.slice(0);
                        ctrl.recipients.endOfData = result.endOfData;

                        ctrl.search(); // Using this method to update UI, couldn't use apply method.
                    });
            }

            ctrl.expandRecipients = function () {
                ctrl.recipients.studentRecipients.forEach(function (recipient) {
                    recipient.show = true;
                });
            };

            ctrl.collapseRecipients = function () {
                ctrl.recipients.studentRecipients.forEach(function (recipient) {
                    recipient.show = false;
                });
            };

            ctrl.search = function () {
                if (ctrl.searchValue.length == 0) {
                    ctrl.filteredRecipients = ctrl.recipients.studentRecipients.slice(0);
                    ctrl.filteredRecipients.forEach(function (sr) {
                        sr.show = false || (ctrl.model.selectedStudent && sr.studentUsi == ctrl.model.selectedStudent.studentUsi);
                    });
                }
                else {
                    ctrl.filteredRecipients = ctrl.recipients.studentRecipients.filter(function (sr) {
                        return sr.fullName.toUpperCase().includes(ctrl.searchValue.toUpperCase()) || sr.recipients.some(function (r) { return r.fullName.toUpperCase().includes(ctrl.searchValue.toUpperCase()) });
                    });
                    ctrl.filteredRecipients.forEach(function (sr) { sr.show = true; });
                }
            };

            ctrl.$onInit = function () {
                ctrl.model = {};
                ctrl.filteredRecipients = ctrl.recipients.studentRecipients.slice(0);


                ctrl.model.selectedStudent = ctrl.recipients.studentRecipients
                    .find(function (x) { return x.studentUsi == ctrl.studentUsi });

                if (ctrl.model.selectedStudent) {
                    if (ctrl.model.selectedStudent.recipients.length > 0)
                        ctrl.model.selectedStudent.show = true;
                    else
                        toastr.error($translate.instant('Student with no Parents') + ".");
                }

                if (!ctrl.recipients.endOfData)
                    ctrl.getAllRecipients();


                if (ctrl.chatModel) {
                    ctrl.model.selectedRecipient = ctrl.model.selectedStudent.recipients.find(function (x) { return x.uniqueId == ctrl.chatModel.recipient.uniqueId });
                    ctrl.model.selectedStudent.unreadMessageCount -= ctrl.model.selectedRecipient.unreadMessageCount;
                    ctrl.model.selectedRecipient.unreadMessageCount = 0;
                }
                
                // By default select English as the lang
                ctrl.selectedLanguage = ctrl.languages.find(function (lang) { return lang.code == ctrl.sender.languageCode }) || ctrl.languages[0];
            };
        }]
    });