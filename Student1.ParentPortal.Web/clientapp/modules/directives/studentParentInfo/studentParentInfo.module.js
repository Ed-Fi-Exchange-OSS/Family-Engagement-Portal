angular.module('app.directives')
    .component('studentParentInfo', {
        bindings: {
            model: "<"
        },
        templateUrl: 'clientapp/modules/directives/studentParentInfo/studentParentInfo.view.html',
        controllerAs: 'ctrl',
        controller: [function () {
            var ctrl = this;
        }]
    });