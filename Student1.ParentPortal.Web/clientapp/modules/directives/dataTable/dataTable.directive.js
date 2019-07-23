angular.module('app.directives')
    .directive('myDataTable', [function () {
        return {
            restrict: 'AEC', // This will be only available on the Element
            scope: {
                options: '='
            },
            transclude: true,
            templateUrl: 'clientapp/modules/directives/dataTable/dataTable.view.html',
            controllerAs: 'ctrl',
            controller: ['$scope', '$http', function ($scope, $http) {
                var ctrl = this;

                ctrl.options = {
                    resourceUrl: $scope.resourceUrl,
                    default:1,
                };

                //merge external options with default options
                angular.merge(ctrl.options, $scope.options);

                var requestData = {};

                $http.get(ctrl.options.resourceUrl)
                    .then(function (response) {
                        ctrl.model = response.data;
                    });
            }]
        }
    }]);