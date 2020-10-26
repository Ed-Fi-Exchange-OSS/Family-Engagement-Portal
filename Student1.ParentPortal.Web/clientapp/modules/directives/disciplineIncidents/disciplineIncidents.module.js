angular.module('app.directives')
    .component('disciplineIncidents', {
        bindings: {
            model: "<",
            studentUsi: "<",
            studentUniqueId: "<"
        },
        templateUrl: 'clientapp/modules/directives/disciplineIncidents/disciplineIncidents.view.html',
        controllerAs: 'ctrl',
        controller: ['appConfig', function (appConfig) {
            var ctrl = this;
            ctrl.heroClient = appConfig.hero.client;
        }]
    });