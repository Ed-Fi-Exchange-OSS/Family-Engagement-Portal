angular.module('app.directives')
    .directive('onScroll', function () {
        var previousScroll = 0;
        var link = function ($scope, $element, attrs) {
            $element.bind('scroll', function (evt) {
                var currentScroll = $element.scrollTop();
                $scope.$eval(attrs["onScroll"], { $event: evt, $direct: currentScroll });
            });
        };
        return {
            restrict: "A",
            link: link
        };
    });