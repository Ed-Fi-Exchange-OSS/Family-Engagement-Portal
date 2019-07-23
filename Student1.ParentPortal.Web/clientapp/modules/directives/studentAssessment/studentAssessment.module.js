angular.module('app')
    .component('studentAssessment', {
        bindings: {
            model: '<', // One way data binding. ( '=' Two way binding, '@' Textual binding, '&' Function/Callback binding)
            assessment: '<',
            color: '@'
        }, 
        templateUrl: 'clientapp/modules/directives/studentAssessment/studentAssessment.view.html',
        controllerAs: 'ctrl',
        controller: [function () {
            var ctrl = this;
        }]
    });