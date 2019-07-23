angular.module('app')
    .component('personProfile', {
        bindings: {
            model: '<' // One way data binding. ( '=' Two way binding, '@' Textual binding, '&' Function/Callback binding)
        }, 
        templateUrl: 'clientapp/modules/directives/personProfile/personProfile.view.html',
        controllerAs: 'ctrl',
        controller: [function () {
            var ctrl = this;
        }]
    });