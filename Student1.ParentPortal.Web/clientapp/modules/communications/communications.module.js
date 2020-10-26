angular.module('app')
    .config(['$stateProvider', function ($stateProvider) {
        $stateProvider.state('app.communications', {
            url: '/communications/:?studentUsi/:&recipientUniqueId/:&recipientTypeId/&:{unreadData:json}',
            requireADLogin: true,
            views: {
                'content@': { component: 'communications' }
            },
            resolve: {
                studentUsi: ['$stateParams', function ($stateParams) {
                    return $stateParams.studentUsi;
                }],
                sender: ['api', function (api) { return api.me.getMyBriefProfile(); }],
                recipients: ['$stateParams', 'api', function ($stateParams, api) {
                    return api.communications.allRecipients({ studentUsi: $stateParams.studentUsi, rowsToSkip: 0, rowsToRetrieve: 500 });
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
            studentUsi: "<",
        }, // One way data binding.
        templateUrl: 'clientapp/modules/communications/communications.view.html',
        controllerAs: 'ctrl',
        controller: ['api', '$translate', '$timeout', '$rootScope', 'landingRouteService', 'signalRService', '$location', 'unreadMessagesServices',
            function (api, $translate, $timeout, $rootScope, landingRouteService, signalRService, $location, unreadMessagesServices) {

                var ctrl = this;
                ctrl.urls = [];
                ctrl.simultaneousTranslation = false;
                ctrl.recipientsLoading = false;
                ctrl.filteredRecipients = [];
                ctrl.searchValue = '';
                ctrl.simultaneousTranslationDone = false;
                ctrl.headerChatStyle = 'col-lg-12';

                // Get the Url for the breadcrumb
                landingRouteService.getRoute().then(function (route) {
                    ctrl.urls.push({ url: route, displayName: $translate.instant('Home') });
                });
                
                // SignalR hub
                $rootScope.$on('messageReceived', function (event, current, previous) {
                    readUnreadMessages();
                    var model = JSON.parse(current);
                    // Only add message if the message is for the current user.
                    if ($location.url().indexOf('communications') != -1) {
                        ctrl.unreadMessageCountChange();
                        if (ctrl.chatModel != null && ctrl.model.selectedRecipient.uniqueId == model.senderUniqueId)
                            ctrl.chatModel.conversation.messages.push(model);

                        // Update that message was read while online
                        if (ctrl.sender.uniqueId === model.recipientUniqueId && ctrl.sender.personTypeId === model.recipientTypeId) {
                            model.read = true;
                            api.communications.recipientRead(model);
                        }
                        ctrl.scrollToEndOfChat();
                    }
                });

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
                        ctrl.chatModel = null;
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
                        ctrl.chatModel = chatModel;
                        ctrl.model.selectedRecipient.unreadMessageCount = 0;
                        ctrl.model.selectedRecipient.imageUrl = chatModel.recipient.imageUrl;
                        ctrl.model.selectedStudent.imageUrl = chatModel.student.imageUrl;
                        ctrl.scrollToEndOfChat();

                        ctrl.simultaneousTranslation = true;


                        if (ctrl.model.selectedRecipient.personTypeId == 1 &&
                            (ctrl.model.selectedRecipient.languageCode == null ||
                                ctrl.model.selectedRecipient.languageCode == 'en')) {
                            ctrl.simultaneousTranslation = false;
                        }

                        if (ctrl.model.selectedRecipient.personTypeId == 2 && (ctrl.sender.languageCode == 'en' || ctrl.sender.languageCode == null)) {
                            ctrl.simultaneousTranslation = false;
                        }

                        readUnreadMessages();
                        ctrl.headerChatStyleChange();
                        ctrl.onLanguageChange();
                        ctrl.unreadMessageCountChange()
                    });
                };

                function readUnreadMessages() {
                    $rootScope.$broadcast("readMessages", true);
                }

                ctrl.loadMore = function () {
                    // API call get another 15 messages.

                    var request = { studentUsi: ctrl.model.selectedStudent.studentUsi, recipientUniqueId: ctrl.model.selectedRecipient.uniqueId, recipientTypeId: ctrl.model.selectedRecipient.personTypeId, rowsToSkip: ctrl.chatModel.conversation.messages.length };

                    api.communications.getChatThread(request).then(function (chatModel) {
                        if (ctrl.selectedLanguage.code) {
                            ctrl.updateMessagesLanguage(chatModel.conversation.messages, ctrl.selectedLanguage.code);
                        }

                        ctrl.chatModel.conversation.endOfMessageHistory = chatModel.conversation.endOfMessageHistory;

                        $timeout(function () {
                            $rootScope.$apply(function () {
                                ctrl.chatModel.conversation.messages = chatModel.conversation.messages.concat(ctrl.chatModel.conversation.messages);
                            });
                        });
                    });
                };

                // Send message
                ctrl.sendMessage = function () {
                    if (!ctrl.model.message || ctrl.model.message.length == 0)
                        return;

                    while (ctrl.simultaneousTranslation && !ctrl.simultaneousTranslationDone) {  /* waiting for translation to end */ };
                    ctrl.simultaneousTranslationDone = false;

                    if (ctrl.model.selectedRecipient.personTypeId != 1) {
                        if (ctrl.sender.languageCode != 'en' && ctrl.sender.languageCode != null ) {
                            var originalMessage = ctrl.model.message;
                            ctrl.model.message = ctrl.model.translatedMessage;
                            ctrl.model.translatedMessage = originalMessage;
                        }
                    }

                    // Call SignalR.
                    var chatModel = {
                        studentUniqueId: ctrl.model.selectedStudent.studentUniqueId,
                        recipientUniqueId: ctrl.model.selectedRecipient.uniqueId,
                        recipientTypeId: ctrl.model.selectedRecipient.personTyId,
                        recipientTypeId: ctrl.model.selectedRecipient.personTypeId,
                        translatedMessage: ctrl.simultaneousTranslation ? ctrl.model.translatedMessage : null  ,
                        englishMessage: ctrl.model.message,
                        translatedLanguageCode: ctrl.model.selectedRecipient.personTypeId == 1 ? ctrl.model.selectedRecipient.languageCode : ctrl.selectedLanguage.code
                    };
                    // Call API that will persist and call the SignalR Hub to update clients.
                    api.communications.postMessage(chatModel).then(function (data) {
                        ctrl.model.message = '';
                        ctrl.model.translatedMessage = '';
                        ctrl.chatModel.conversation.messages.push(data);

                        ctrl.scrollToEndOfChat();
                    });
                };

                // Change Lang
                ctrl.onLanguageChange = function () {
                    if (ctrl.selectedLanguage.code != 'en') {
                        ctrl.updateMessagesLanguage(ctrl.selectedLanguage.code);
                    }
                };


                ctrl.updateMessagesLanguage = function (code) {
                    ctrl.chatModel.conversation.messages.forEach(function (m) {
                        api.translate.autoDetectTranslate({ textToTranslate: m.englishMessage, toLangCode: code })
                            .then(function (t) {
                                console.log(t);
                                m.translatedMessage = t;
                            });
                    });


                };

                // Do simultaneous translation
                ctrl.simulTran = function (code) {
                    if (!ctrl.simultaneousTranslation)
                        return;

                    if (code == null) {
                        code = ctrl.selectedLanguage.code;
                    }
                    if (ctrl.model.selectedRecipient.personTypeId == 2 && code != 'en') {
                        ctrl.selectedLanguage.code = 'en';
                        code = 'en';
                    }

                    if (ctrl.model.message.length > 2) {
                        $rootScope.loadingOverride = true;
                        api.translate.autoDetectTranslate({ textToTranslate: ctrl.model.message, toLangCode: code })
                            .then(function (t) {
                                ctrl.model.translatedMessage = t;
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
                    api.communications.allRecipients({ rowsToSkip: ctrl.recipients.studentRecipients.length, rowsToRetrieve: 100 })
                        .then(function (result) {
                            if (!result.endOfData)
                                ctrl.getAllRecipients();
                            else {
                                $rootScope.loadingOverride = false;
                                ctrl.recipientsLoading = false;
                            }
                            ctrl.checkAvatar(result.studentRecipients);
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
                            return sr.fullName.toUpperCase().indexOf(ctrl.searchValue.toUpperCase()) != -1 || sr.recipients.some(function (r) { return r.fullName.toUpperCase().indexOf(ctrl.searchValue.toUpperCase()) != -1 });
                        });
                        ctrl.filteredRecipients.forEach(function (sr) { sr.show = true; });
                    }
                };

                ctrl.getNameLanguage = function (code) {
                    if (code == undefined) {
                        return "Not Yet Selected (English)"
                    }
                    var model = ctrl.languages.find(function (lang) { return lang.code == code });
                    return model.name;
                }

                ctrl.randomAvatarColor = function() {
                    return "hsla(" + ~~(360 * Math.random()) + "," +
                        "70%," +
                        "80%,1)"
                }

                ctrl.checkAvatar = function (recipients) {
                    recipients.forEach(function (fr) {
                        if (fr.imageUrl == null || fr.imageUrl == "") {
                            fr.avatar = {
                                color: ctrl.randomAvatarColor(),
                                name: fr.firstName.charAt(0) + fr.lastSurname.charAt(0)
                            }
                        }
                        fr.recipients.forEach(function (r) {
                            if (r.imageUrl == null || r.imageUrl == "") {
                                r.avatar = {
                                    color: ctrl.randomAvatarColor(),
                                    name: r.firstName.charAt(0) + r.lastSurname.charAt(0)
                                }
                            }
                        })

                    });
                }

                ctrl.headerChatStyleChange = function () {
                    if (ctrl.model.selectedRecipient.personTypeId == 1)
                        ctrl.headerChatStyle = 'col-lg-12';
                    else
                        ctrl.headerChatStyle = 'col-lg-6';
                }

                ctrl.unreadMessageCountChange = function () {
                    api.communications.recipientUnread().then(function (data) {
                        if (ctrl.model.selectedStudent != null) {
                            ctrl.model.selectedStudent.unreadMessageCount = data.unreadMessagesCount;
                            var studentRecipients = ctrl.filteredRecipients.find(function (r) {
                                return r.studentUniqueId == ctrl.model.selectedStudent.studentUniqueId;
                            }).recipients;
                        }
                   });
                }

                ctrl.$onInit = function () {

                    ctrl.model = {};
                    ctrl.filteredRecipients = ctrl.recipients.studentRecipients.slice(0);
                    ctrl.checkAvatar(ctrl.recipients.studentRecipients);

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

                    $rootScope.$on('$translateChangeSuccess', function (event, current, previous) {
                        ctrl.sender.languageCode = $translate.use();

                    });


                    $rootScope.$on('LanguageChange', function ($event, data, current) {
                        ctrl.sender.languageCode = data.code;
                        ctrl.selectedLanguage.code = data.code;
                        if (data.code != 'en')
                            ctrl.simultaneousTranslation = true;
                    });

                    $rootScope.$on('chatLanguageChange', function ($event, data, current) {
                        ctrl.sender.languageCode = data.code;
                        ctrl.selectedLanguage.code = data.code;
                        if (data.code != 'en')
                            ctrl.simultaneousTranslation = true;
                    });


                };
            }]
    });