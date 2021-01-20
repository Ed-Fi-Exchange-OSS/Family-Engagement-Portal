//require('./attendance-calendar.style.scss');
angular
    .module('app.directives')
    .directive('studentAttendanceCalendarList', ['api', function (api) {
        return {
            restrict: 'E',
            scope: {
                model: '='
            },
            templateUrl: 'clientapp/modules/directives/studentAttendanceCalendar/studentAttendanceCalendarList.view.html',
            controllerAs: 'ctrl',
            controller: ['$scope', function (scope) {

                var ctrl = this;

                const calendarsPerRow = 4;
                ctrl.model =
                    // Group by rows of 4 months each
                    scope.model.reduce(function (accumulator, currentValue, currentIndex) {
                        let idx = ~~(currentIndex / calendarsPerRow); // Integer result of division
                        if (accumulator[idx] == null) { accumulator[idx] = []; }
                        let row = accumulator[idx];
                        row.push(currentValue);
                        return accumulator;
                    }, []);
            }]
        };
    }]);