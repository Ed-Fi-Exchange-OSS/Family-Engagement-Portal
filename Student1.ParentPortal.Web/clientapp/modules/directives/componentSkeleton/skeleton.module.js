angular.module('app.directives')
    .component('directiveComponentSkeleton', {
        bindings: {
            model: '<' // One way data binding. ( '=' Two way binding, '@' Textual binding, '&' Function/Callback binding)
        }, 
        templateUrl: 'clientapp/modules/directives/skeleton/skeleton.view.html',
        controllerAs: 'ctrl',
        controller: [function () {
            var ctrl = this;
        }]
    });