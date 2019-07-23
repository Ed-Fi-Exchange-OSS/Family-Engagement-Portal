angular.module('app.directives')
    .component('disciplineIncidents', {
        bindings: {
            model: "<"
        },
        templateUrl: 'clientapp/modules/directives/disciplineIncidents/disciplineIncidents.view.html',
        controllerAs: 'ctrl',
        controller: [function () {
            var ctrl = this;

        }]
    });