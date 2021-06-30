angular.module('app.directives')
    .component('starDetail', {
        bindings: {
            widgetTitle: '@',
            widgetSubTitle: '@',
            color: '@',
            tooltip: '@',
            indicatorCategories: '<', // [{tooltip:'', value: 10, interpretation: ''}]
            anchorid: '@',
            textualEvaluation: '<',
            model:'<',
            bgclass: '@'
        },
        templateUrl: 'clientapp/modules/directives/studentAssessment/starDetail.view.html',
        controllerAs: 'ctrl',
        controller: ['$location',function ($location) {
            var ctrl = this;
            ctrl.$onChanges = function (changes) {
                // prevent using reduce on empty array before time
                if (ctrl.model != null) {
                    result = ctrl.model.reduce(function (r, a) {
                        r[a.mainName] = r[a.mainName] || [];
                        r[a.mainName].title = a.mainName;
                        r[a.mainName].administrationDate = a.administrationDate;
                        if (r[a.mainName].items == undefined) r[a.mainName].items = [];
                        r[a.mainName].items.push(a);
                        return r;
                    }, Object.create(null));
                    ctrl.groupInfo = result;
                }
            }
            this.$onInit = function () {
                // prevent using reduce on empty array before time
                if (ctrl.model != null) {
                    result = ctrl.model.reduce(function (r, a) {
                        r[a.mainName] = r[a.mainName] || [];
                        r[a.mainName].title = a.mainName;
                        r[a.mainName].administrationDate = a.administrationDate;
                        if (r[a.mainName].items == undefined) r[a.mainName].items = [];
                        r[a.mainName].items.push(a);
                        return r;
                    }, Object.create(null));
                    ctrl.groupInfo = result;
                }
            };

            ctrl.getHashKeyClean = function (hashKey) {
                return hashKey.replace(':', '');
            }

            ctrl.starEnter = function (element, typeElement) {
                if (element.englishResult != null && element.spanishResult != null) {
                    let result = element.englishResult - element.spanishResult;
                    if (result < 0) result = result * -1;
                    if (result >= 0 && result <= 5) {
                        if (typeElement == 'eng') {
                            $('#star_esp_' + ctrl.getHashKeyClean(element.$$hashKey)).hide();
                        }
                        else {
                            $('#star_eng_' + ctrl.getHashKeyClean(element.$$hashKey)).hide();
                        }
                    }
                }
            }

            ctrl.starLeave = function (element) {
                if (element.englishResult != null && element.spanishResult != null) {
                    $('#star_esp_' + ctrl.getHashKeyClean(element.$$hashKey)).show();
                    $('#star_eng_' + ctrl.getHashKeyClean(element.$$hashKey)).show();
                }
            }

        }]
    });