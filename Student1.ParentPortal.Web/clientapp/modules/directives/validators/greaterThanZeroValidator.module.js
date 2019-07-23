
angular.module('app.directives')
    .directive('greaterThanZero', greaterThanZero);
function greaterThanZero() {
    return {
        restrict: 'A',
        require: 'ngModel',
        link: function (scope, element, attributes,control) {
            control.$validators.gtZero = function (modelValue,viewValue) {
                var value = Number(viewValue);
                return value > 0;
            };
        }
    }
}