angular.module('app')
    .component('studentCardGrid', {
        bindings: {
            model: "<",
            search: "<",
            orderby: "<"
        }, // One way data binding.
        templateUrl: 'clientapp/modules/directives/studentCardGrid/studentCardGrid.view.html',
        controllerAs: 'ctrl',
        controller: [function () {
            var ctrl = this;
        }]
    });