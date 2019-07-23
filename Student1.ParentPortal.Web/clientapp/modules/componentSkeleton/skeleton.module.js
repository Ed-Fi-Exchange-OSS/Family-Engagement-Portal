angular.module('app')
    .config(['$stateProvider', function($stateProvider) {
        $stateProvider.state('app.skeleton',{
            url: '/skeleton',
            views: {
                'navbar': 'navbar',
                'content@': 'skeleton'
                }
            });
    }])
    .component('skeleton', {
        bindings: {
            model: "<"
        }, // One way data binding.
        templateUrl: 'clientapp/modules/componentSkeleton/skeleton.view.html',
        controllerAs: 'ctrl',
        controller: [function () {}]
    });