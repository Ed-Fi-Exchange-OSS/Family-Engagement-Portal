angular.module('app')
    .config(['$stateProvider', function ($stateProvider) {
        $stateProvider.state('app.privacypolicy',
                {
                    url: '/privacypolicy',
                    views: {
                        'navbar@': '',
                        'content@': 'privacypolicy'
                    },
                });
        }
    ])
    .component('privacypolicy', {
        templateUrl: 'clientapp/modules/privacypolicy/privacypolicy.view.html',
        controllerAs: 'ctrl',
        controller: [function () {
            var ctrl = this;

            ctrl.goBack = function() {
                window.history.back();
            };
        }]
    });