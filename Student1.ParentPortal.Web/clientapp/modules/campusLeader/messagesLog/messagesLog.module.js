angular.module('app')
    .component('messagesLog', {
        bindings: {
            sender: "<",
            grades: '<',
            programs: '<',
            queues: '<',
            execute: '<'
        },
        templateUrl: 'clientapp/modules/campusLeader/messagesLog/messagesLog.view.html',
        controllerAs: 'ctrl',
        controller: ['api', 'signalRService', '$timeout', '$rootScope', function (api, signalRService, $timeout, $rootScope) {
            var ctrl = this;
            ctrl.recipients = {};
            ctrl.messagesPending = [];
            ctrl.recipient = {};
            ctrl.recipientSelected = false;
            ctrl.gmDetail = false;
            ctrl.imDetail = false;
            ctrl.selectedQueue = {};
            ctrl.searchMessageLog = {};
            ctrl.searchIndividualLog = {};
            ctrl.messagesCount = 0;
            ctrl.onlyUnreadMessages = true;
            ctrl.onlyOnePerScroll = 0;
            ctrl.relationship = '';
            ctrl.simultaneousTranslation = false;

            ctrl.unreadMessagesNotFound = false;

            ctrl.$onInit = function () {

                ctrl.selectedGrade = ctrl.grades[0];

                ctrl.selectedProgram = ctrl.programs[0];

                ctrl.selectQueue(ctrl.queues[0]);


                ctrl.gradeLevelIds = ctrl.grades.map(function (g) {
                    return g.id;
                });

                ctrl.programIds = ctrl.programs.map(function (p) { return p.id; });

                ctrl.changeTab('gm');

                $rootScope.$on('getQueues', function ($event, data, current) {
                    ctrl.getAllQueues();
                    ctrl.getPrincipalRecipientMessages();
                });
            };

            ctrl.getAllQueues = function () {
                api.me.getSchool().then(function (schoolId) {
                    api.communications.getGroupMessagesQueues(schoolId, {
                        from: null,
                        to: null,
                        gradeLevels: [],
                        programs: []
                    }).then(function (data) {
                        ctrl.queues = data;
                        if (ctrl.queues.length > 0) {
                            ctrl.selectQueue(ctrl.queues[0]);
                        };
                    });
                });
            };

            ctrl.OnGradeChange = function () {
                if (ctrl.selectedGrade.id != 0) {
                    ctrl.gradeLevelIds = [];
                    ctrl.gradeLevelIds.push(ctrl.selectedGrade.id);
                } else {
                    ctrl.gradeLevelIds = ctrl.grades.map(function (g) { return g.id; });
                    ctrl.selectedGrade = ctrl.grades[0];
                }
                ctrl.advanceSearch();
            };

            ctrl.OnProgramChange = function () {
                if (ctrl.selectedProgram.id != 0) {
                    ctrl.programIds = [];
                    ctrl.programIds.push(ctrl.selectedProgram.id);

                } else {
                    ctrl.programIds = ctrl.programs.map(function (p) {
                        return p.id;
                    });
                }
                ctrl.advanceSearch();
            };

            ctrl.advanceSearch = function () {
                ctrl.selectedQueue = {};
                if (ctrl.gradeLevelIds[0] == 0)
                    ctrl.gradeLevelIds.shift()
                if (ctrl.programIds[0] == 0)
                    ctrl.programIds.shift();

                if (!ctrl.searchMessageLog.value)
                    ctrl.searchMessageLog.value = null;
                var fromDate = null;
                var toDate = null;

                if (ctrl.filters) {
                    fromDate = ctrl.filters.fromDate
                    toDate = ctrl.filters.toDate;
                } 
                api.me.getSchool().then(function (schoolId) {
                    api.communications.getGroupMessagesQueues(schoolId, {
                        from: fromDate,
                        to: toDate,
                        gradeLevels: ctrl.gradeLevelIds,
                        programs: ctrl.programIds,
                        searchTerm: ctrl.searchMessageLog.value
                    }).then(function (data) {
                        ctrl.queues = data;
                        if (ctrl.queues.length > 0) {

                            ctrl.selectQueue(ctrl.queues[0]);
                        };
                    });
                });

            };

            ctrl.selectRecipient = function (recipient) {
                ctrl.message = {};
                ctrl.recipientSelected = true;
                ctrl.relationship = recipient.relationToStudent;
                ctrl.messagesPending.forEach(function (mp) {
                    mp.selected = false;
                    if (mp.uniqueId == recipient.uniqueId) {
                        mp.selected = true;
                    }
                })
                ctrl.recipient = recipient;
                ctrl.getChatThread(recipient.studentUsi, recipient.uniqueId, 1, 0);
            };

            ctrl.getChatThread = function (studentUsi, recipientUniqueId, recipientTypeId, unreadMessageCount) {
                var request = { studentUsi: studentUsi, recipientUniqueId: recipientUniqueId, recipientTypeId: recipientTypeId, unreadMessageCount: unreadMessageCount };
                api.communications.getChatThread(request).then(function (chatModel) {
                    ctrl.recipients = chatModel;
                    ctrl.scrollToEndOfChat();

                    ctrl.simultaneousTranslation = true;

                    if (ctrl.recipient.languageCode == 'en' || ctrl.recipient.languageCode == null) {
                        ctrl.simultaneousTranslation = false;
                    }
                });
            };

            ctrl.scrollToEndOfChat = function () {
                $timeout(function () {
                    var scroller = document.getElementById("message-history");
                    scroller.scrollTop = scroller.scrollHeight;
                }, 0, false);
            };

            // SignalR hub
            var chatHub = signalRService.init('ChatHub');

            chatHub.on('messageReceived', function (message) {
                var model = JSON.parse(message);
                // Only add message if the message is for the current user.
                    ctrl.recipients.conversation.messages.push(model);
                    // Update that message was read while online
                    if (ctrl.sender.uniqueId === model.recipientUniqueId && ctrl.sender.personTypeId === model.recipientTypeId) {
                        model.read = true;
                        api.communications.recipientRead(model);
                    }

                ctrl.scrollToEndOfChat();

            });

            chatHub.start();

            // Send message
            ctrl.sendMessage = function () {
                if (!ctrl.message.value || ctrl.message.value.length == 0)
                    return;

                // Call SignalR.
                var chatModel = {
                    studentUniqueId: ctrl.recipient.studentUniqueId,
                    recipientUniqueId: ctrl.recipient.uniqueId,
                    recipientTypeId: 1,
                    englishMessage: ctrl.message.value,
                    translatedMessage: ctrl.recipient.translatedMessage ,
                    translatedLanguageCode: ctrl.recipient.languageCode
                };
                // Call API that will persist and call the SignalR Hub to update clients.
                api.communications.postMessage(chatModel).then(function (data) {
                    ctrl.message.value = '';
                    ctrl.recipients.conversation.messages.push(data);
                    ctrl.scrollToEndOfChat();
                });
            };

            ctrl.changeTab = function (tab) {
                if (tab == 'gm') {
                    ctrl.gmDetail = true;
                    ctrl.imDetail = false;
                }
                if (tab == 'im') {
                    ctrl.imDetail = true;
                    ctrl.gmDetail = false;
                }
                    
            };

            ctrl.selectQueue = function (queue) {
                ctrl.selectedQueue = queue;
                ctrl.queues.forEach(function (q) {
                    q.selected = false;
                });

                ctrl.queues.forEach(function (q) {
                    if (q.id == queue.id)
                        q.selected = true;
                });
            };

            ctrl.scrollSearchCount = 1;
            ctrl.getPrincipalRecipientMessages = function (isScroll) {
                ctrl.unreadMessagesNotFound = false;
                if (!isScroll) {
                    ctrl.messagesPending = [];
                }

                if (!ctrl.searchIndividualLog.value)
                    ctrl.searchIndividualLog.value = null;

                var request = {
                    rowsToSkip: ctrl.messagesPending.length,
                    rowsToRetrive: 50,
                    searchTerm: ctrl.searchIndividualLog.value,
                    onlyUnreadMessages: ctrl.onlyUnreadMessages
                };
                api.communications.principalRecipientMessages(request).then(function (data) {
                    ctrl.recipientCount = data.recipientCount;
                    if (ctrl.onlyUnreadMessages && data.messages.length == 0)
                        ctrl.unreadMessagesNotFound = true;

                    if (!isScroll) {
                        ctrl.messagesPending = data.messages;
                        ctrl.messagesPending.forEach(function (mp) {
                            mp.selected = false;
                        });
                    } else {
                        ctrl.scrollSearchCount++;
                        data.messages.forEach(function (d) {
                            d.selected = false;
                            ctrl.messagesPending.push(d);
                        });
                    }
                    ctrl.onlyOnePerScroll = 0;
                });
            };

            ctrl.scrollEventIndividualLog = function () {
                var table = document.getElementById("list-individual-chat");
                if (table.offsetHeight + table.scrollTop >= table.scrollHeight) {
                    ctrl.onlyOnePerScroll++
                    if (ctrl.onlyOnePerScroll == 1) {
                       ctrl.getPrincipalRecipientMessages(true);
                    }
                }
            }

            ctrl.loadMore = function () {
                // API call get another 15 messages.

                var request = { studentUsi: ctrl.recipient.studentUsi, recipientUniqueId: ctrl.recipient.uniqueId, recipientTypeId: 1, rowsToSkip: ctrl.recipients.conversation.messages.length };

                api.communications.getChatThread(request).then(function (chatModel) {
                    ctrl.recipients.conversation.endOfMessageHistory = chatModel.conversation.endOfMessageHistory;
                    ctrl.recipients.conversation.messages =  chatModel.conversation.messages.concat(ctrl.recipients.conversation.messages);
                });
            };

            ctrl.getUnreadMessagesOnly = function () {
                ctrl.getPrincipalRecipientMessages();
            }

            // Do simultaneous translation
            ctrl.simulTran = function (code) {
                if (!ctrl.simultaneousTranslation)
                    return;
                if (code == null)
                    code = 'en';

                if (ctrl.message.value.length > 2) {
                    $rootScope.loadingOverride = true;
                    api.translate.autoDetectTranslate({ textToTranslate: ctrl.message.value, toLangCode: code })
                        .then(function (t) {
                            ctrl.recipient.translatedMessage = t;
                            ctrl.simultaneousTranslationDone = true;
                            $rootScope.loadingOverride = false;
                        });
                }

            };
        }]
    });