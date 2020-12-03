angular.module('app')
    .component('individualMessages', {
        bindings: {
            grades: '<',
            languages: '<',
            schoolId: '<'
        },
        templateUrl: 'clientapp/modules/campusLeader/individualMessages/individualMessages.view.html',
        controllerAs: 'ctrl',
        controller: ['api', '$translate', '$uibModal', '$rootScope', 'stateStorage', function (api, $translate, $uibModal, $rootScope, stateStorage) {
            var ctrl = this;

            ctrl.search = {};
            ctrl.recipient = '';
            ctrl.studentHasSelect = false;
            ctrl.message = {};
            ctrl.parents = [];
            ctrl.showParentsTable = false;
            ctrl.onlyOnePerScroll = 0;
            ctrl.isCheckedAll = false;
            ctrl.parentsCheckeds = [];
            ctrl.parentsLanguages = [];
            ctrl.showResultEmptyMessage = false;
            ctrl.familyMembersCount = 0;
            ctrl.resetStylesTextArea = '';
            ctrl.resetStylesInput = '';
            ctrl.stateKey = 'individualMessage';
            ctrl.searchEngineExecute = false;
            ctrl.isFromCacheStorage = false;
            ctrl.storageParentsCheckeds = [];

            ctrl.$onInit = function () {

                ctrl.selectedGrade = ctrl.grades[0];

                ctrl.gradesIds = ctrl.grades.map(function (g) {
                    return g.id;
                });

                var state = JSON.parse(stateStorage.getState(ctrl.stateKey));
                if (state != null) {
                    if (state.subject != null)
                        ctrl.message.subject = state.subject;
                    if (state.body != null) {
                        ctrl.message.body = state.body;
                    }

                    if (state.gradelevel != null) {
                        ctrl.selectedGrade = ctrl.grades.find(function (g) { return g.id == state.gradelevel });
                        ctrl.changeGradeLevel();
                    }

                    if (state.search != null)
                        ctrl.search.value = state.search;

                    if (state.searchEngineExecute != undefined && state.searchEngineExecute) {
                        ctrl.getStudentsByGradesAndSearchTerm();
                        ctrl.getParentStudentInGradesAndSearchTermCount();
                        ctrl.isFromCacheStorage = true;
                    }


                    if (state.parentsCheckeds != null && state.parentsCheckeds.length > 0) {
                        ctrl.storageParentsCheckeds = state.parentsCheckeds;
                    }
                }

                $rootScope.$on('changeSchoolEvent', function ($event, data, current) {
                    ctrl.parents = [];
                    ctrl.parentsCheckeds = [];
                    ctrl.parentsLanguages = [];
                });
            }


            ctrl.checkedCheckBox = function (data) {
                var p = ctrl.parents.find(function (s) {
                    return s.parentUsi == data.parentUsi;
                });
                p.isChecked = !p.isChecked;
                ctrl.addParentsToAudience();
                ctrl.filterByLanguage();
                ctrl.saveState();
            }

            ctrl.addParentsToAudience = function () {
                ctrl.recipient = '';
                ctrl.parentsCheckeds = ctrl.parents.filter(function (s) { return s.isChecked == true; });
                if (ctrl.parentsCheckeds.length > 0) {
                    var interval = 0;
                    ctrl.parentsCheckeds.forEach(function (ps) {
                        if (ctrl.parentsCheckeds.length - 1 == interval)
                            ctrl.recipient += ps.parentFirstName + ' ' + ps.parentLastSurname + '';
                        else
                            ctrl.recipient += ps.parentFirstName + ' ' + ps.parentLastSurname + ', ';
                        interval++;
                    });
                    ctrl.studentHasSelect = true;
                } else {
                    ctrl.studentHasSelect = false;
                }
            }

            ctrl.getStudentsByGradesAndSearchTerm = function (isScroll) {

                if (!isScroll) {
                    ctrl.parents = [];
                    ctrl.parentsCheckeds = [];
                    ctrl.parentsLanguages = [];
                    ctrl.showResultEmptyMessage = false;
                    ctrl.recipient = '';
                    ctrl.studentHasSelect = false;
                    ctrl.searchEngineExecute = true;
                    ctrl.saveState();
                }

                if (ctrl.gradesIds[0] == 0)
                    ctrl.gradesIds.shift()

                if (!ctrl.search.value || ctrl.search.value == undefined)
                    ctrl.search.value = '';

                api.communications
                    .getParentStudentInGradesAndSearchTerm({ searchTerm: ctrl.search.value, schoolId: ctrl.schoolId, gradeLevels: { grades: ctrl.gradesIds, pageSize: 100, skipRows: ctrl.parents.length } }).then(function (data) {
                        if (data.length == 0 && ctrl.parents.length == 0)
                            ctrl.showResultEmptyMessage = true;


                        if (ctrl.parents.length > 0) {
                            ctrl.showParentsTable = true;

                            data.forEach(function (student) {
                                if (!ctrl.isCheckedAll)
                                    student.isChecked = false;
                                else {
                                    student.isChecked = true;
                                }
                                ctrl.parents.push(student);
                                if (ctrl.isCheckedAll)
                                    ctrl.addParentsToAudience();
                            })
                        } else {
                            ctrl.showParentsTable = true;
                            ctrl.parents = data;
                            ctrl.parents.forEach(function (student) { student.isChecked = false; });
                        }
                        ctrl.onlyOnePerScroll = 0;

                        if (ctrl.isFromCacheStorage) {
                            ctrl.storageParentsCheckeds.forEach(function (pc) {
                                ctrl.checkedCheckBox(pc);
                            });
                            ctrl.simulTran(ctrl.message.body);
                            ctrl.isFromCacheStorage = false;
                        }
                    });
            }

            ctrl.getParentStudentInGradesAndSearchTermCount = function () {

                if (ctrl.gradesIds[0] == 0)
                    ctrl.gradesIds.shift()

                if (!ctrl.search.value || ctrl.search.value == undefined)
                    ctrl.search.value = '';

                api.communications.getParentsCountInGreadesAndSearchTermCount({ searchTerm: ctrl.search.value, schoolId: ctrl.schoolId, gradeLevels: { grades: ctrl.gradesIds, pageSize: null, skipRows: 0 } })
                    .then(function (data) {
                        ctrl.familyMembersCount = data;
                    });
            }

            ctrl.handlerMethodContact = function (value) {
                if (value == null || value == 0) {
                    return 'Email';
                } else if (value == 1) {
                    return 'Email';
                } else if (value == 2) {
                    return 'SMS';
                } else if (value == 3) {
                    return 'Push Notification'
                }
            }

            ctrl.handlerLanguage = function (value) {
                if (!value || value == null || value == "null") {
                    value = 'en';
                }
                var language = ctrl.languages.find(function (lg) { return lg.code == value });
                return language.name;
            }

            ctrl.changeGradeLevel = function () {
                ctrl.isCheckedAll = false;
                if (ctrl.selectedGrade == undefined)
                    ctrl.selectedGrade = ctrl.grades[0];
                if (ctrl.selectedGrade.id == 0) {
                    ctrl.gradesIds = ctrl.grades.map(function (g) {
                        return g.id;
                    });
                } else {
                    ctrl.gradesIds = [];
                    ctrl.gradesIds.push(ctrl.grades.find(function (g) {
                        return g.id == ctrl.selectedGrade.id;
                    }).id);
                }
            }

            ctrl.simulTran = function (message) {
                ctrl.resetStylesTextArea = 'ng-touched';
                if (message) {
                    ctrl.parentsLanguages.forEach(function (trans) {
                        api.translate.autoDetectTranslate({ textToTranslate: message, toLangCode: trans.code })
                            .then(function (translate) {
                                trans.translateText = translate;
                            });
                    });
                }
            }

            ctrl.scrollEvent = function () {
                var table = document.getElementById("tableResult");
                if (table.offsetHeight + table.scrollTop >= table.scrollHeight) {
                    ctrl.onlyOnePerScroll++
                    if (ctrl.onlyOnePerScroll == 1) {
                        ctrl.getStudentsByGradesAndSearchTerm(true);
                    }
                }
            }

            ctrl.checkAllCheckBoxes = function () {
                if (ctrl.parents.length > 0) {
                    ctrl.isCheckedAll = !ctrl.isCheckedAll;
                    ctrl.parents.forEach(function (s) {
                        s.isChecked = ctrl.isCheckedAll;
                    });
                    ctrl.addParentsToAudience();
                    ctrl.filterByLanguage();
                }

            }

            ctrl.filterByLanguage = function () {
                if (ctrl.parentsCheckeds.length > 0) {
                    var groupLanguage = ctrl.parentsCheckeds.reduce(function (r, a) {
                        r[a.languageCode] = [...r[a.languageCode] || [], a];
                        return r;
                    }, {});

                    ctrl.parentsLanguages = [];
                    Object.keys(groupLanguage).forEach(function (key) {
                        var isAddedCode = ctrl.parentsLanguages.find(function (pl) { return pl.code == key });
                        if (isAddedCode) {
                            isAddedCode.value = groupLanguage[key];
                        } else {
                            if (key != 'en' && key != 'null') {
                                ctrl.parentsLanguages.push({
                                    code: key,
                                    value: groupLanguage[key],
                                    translateText: ''
                                });
                            }
                        }
                    });
                } else {
                    ctrl.parentsLanguages = [];
                }
            }

            ctrl.autoExpand = function (e) {
                var element = typeof e === 'object' ? e.target : document.getElementById(e);
                var scrollHeight = element.scrollHeight - 18; // replace 60 by the sum of padding-top and padding-bottom
                element.style.height = scrollHeight + "px";
            };

            ctrl.sendMessage = function () {
                var parentsUsi = ctrl.parentsCheckeds.map(function (pc) { return pc.parentUsi });
                var gradesPerStudents = ctrl.parentsCheckeds.map(function (pc) {
                    var gradeLevel = ctrl.grades.filter(function (g) { return g.name == pc.gradeLevel })[0];
                    return gradeLevel.id;
                });
                var gradesIds = [...new Set(gradesPerStudents)];
                var request = {
                    gradeLevels: gradesIds,
                    parentsUsis: parentsUsi,
                    message: ctrl.message.body.replace(/\n/g, " <br/> "),
                    subject: ctrl.message.subject,
                    schoolId: ctrl.schoolId,
                    audience: `${ctrl.selectedGrade.name} (${ctrl.parentsCheckeds.length} people)`
                };
                api.communications.sendPrincipalIndividualGroupMessage(request).then(function (data) {
                    toastr.success($translate.instant('Message Teacher Sent'));
                    ctrl.message = {};
                    ctrl.parentsCheckeds = [];
                    ctrl.parentsLanguages = [];
                    ctrl.parents.forEach(function (student) { student.isChecked = false; });
                    ctrl.recipient = '';

                    document.getElementById("SubjectMessage").classList.remove("ng-touched");
                    document.getElementById("TextAreaMessage").classList.remove("ng-touched");
                    ctrl.resetStylesTextArea = 'ng-untouched';
                    ctrl.resetStylesInput = 'ng-untouched';
                    stateStorage.removeState(ctrl.stateKey);
                });
            };

            ctrl.confirmSend = function () {
                return new Promise(function (resolve) {

                    ctrl.modalBody = $translate.instant('Principals Modal Message Body One Person');
                    ctrl.buttonLabelCustom = $translate.instant('Principals Modal Button Label One Person');

                    if (ctrl.parentsCheckeds.length > 1) {
                        ctrl.modalBody = $translate.instant('Principals Modal Message Body', { familyCount: ctrl.parentsCheckeds.length });
                        ctrl.buttonLabelCustom = $translate.instant('Principals Modal Button Label', { familyCount: ctrl.parentsCheckeds.length });
                    }

                    var modalInstance = $uibModal.open({
                        component: 'confirmationModal',
                        resolve: {
                            body: function () {
                                return ctrl.modalBody;
                            },
                            confirmButtonLabel: function () {
                                return ctrl.buttonLabelCustom;
                            }
                        }
                    }).result;

                    modalInstance.then(function (result) {
                        if (result)
                            ctrl.sendMessage();
                    }).catch(function (dismiss) { });
                    resolve();
                });
            };

            ctrl.saveState = function () {
                var sub = ctrl.message.subject;
                var body = ctrl.message.body;
                var search = ctrl.search.value;
                if (sub == undefined)
                    sub = null;
                if (body == undefined)
                    body = null;
                if (search == undefined)
                    search = null;


                stateStorage.setState(ctrl.stateKey, JSON.stringify({
                    subject: sub,
                    body: body,
                    gradelevel: ctrl.selectedGrade.id,
                    search: search,
                    parentsCheckeds: ctrl.parentsCheckeds,
                    searchEngineExecute: ctrl.searchEngineExecute
                }));
            };
        }]
    });