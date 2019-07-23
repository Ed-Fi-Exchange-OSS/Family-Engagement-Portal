angular.module('app.directives')
    .directive('cardProgress', [ function () {
        return {
            restrict: 'E',
            scope: {
                title: '@',
                status: '@',
                icon: '@',
                value: '@',
                minRange: '@',
				maxRange: '@'
            },
            templateUrl:"clientapp/modules/directives/cardprogress/cardprogress.view.html",
            controller: ['$scope',function($scope) {
            }]
        };
    }]);