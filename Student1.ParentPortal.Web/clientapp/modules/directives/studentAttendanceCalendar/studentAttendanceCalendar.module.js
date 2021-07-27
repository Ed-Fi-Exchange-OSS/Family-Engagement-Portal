//require('./studentAttendanceCalendar.style.css');
angular
    .module('app.directives')
    .directive('studentAttendanceCalendar', ['api', function (api) {
        return {
            restrict: 'E',
            scope: {
                model: '='
            },
            templateUrl: 'clientapp/modules/directives/studentAttendanceCalendar/studentAttendanceCalendar.view.html',
            controllerAs: 'ctrl',
            controller: ['$scope', '$location', '$anchorScroll', function (scope, $location, $anchorScroll) {
                var ctrl = this;
                var months = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"];
                var startDate = scope.model.date;



                ctrl.getFirstDayOfWeek = function (d) {
                    var date = new Date(d.valueOf());
                    // If Sunday then add 1 day
                    if (date.getDay() == 0)
                        date.setDate(date.getDate() + 1);

                    // If Saturday then add 2 days
                    if (date.getDay() == 6)
                        date.setDate(date.getDate() + 2);

                    return date;
                };

                ctrl.getNextMonday = function (date) {
                    var resultDate = new Date(date.getTime());

                    // If date bing sent is is a Monday we need the next one after this
                    if (resultDate.getDay() == 1)
                        resultDate.setDate(date.getDate() + 1);

                    resultDate.setDate(resultDate.getDate() + (1 + 7 - resultDate.getDay()) % 7);

                    return resultDate;
                };

                ctrl.getDayEvents = function (date) {
                    return scope.model.events
                        .filter(e => e.date.getUTCFullYear() == date.getUTCFullYear()
                            && e.date.getUTCMonth() == date.getUTCMonth()
                            && e.date.getUTCDate() == date.getUTCDate());
                };

                ctrl.getWeeks = function (startDate, schoolYearStartDay = null, schoolYearStopDay = null) {

                    var weeks = [];
                    var month = startDate.getMonth();
                    var firstWeekDay = ctrl.getFirstDayOfWeek(startDate);

                    // Cycle while still in this month.
                    do {
                        var week = new Array(5);

                        var day = firstWeekDay.getUTCDate();
                        for (var i = firstWeekDay.getDay() - 1; i < 5; i++) {
                            var date = new Date(startDate.getUTCFullYear(), startDate.getUTCMonth(), day);
                            // Dont paint if its next month.
                            var outOfSchoolYear = ((schoolYearStartDay || 0) > day);
                            //var outOfSchoolYear = ((schoolYearStartDay || 0) > day) || ((schoolYearStopDay || 9999) < day);
                            var isToday = areSameDay(date, new Date());
                            if (date.getMonth() == month) {
                                var evet = ctrl.getDayEvents(date)
                                week[i] = {
                                    day: date.getDate(),
                                    events: evet,
                                    outOfSchoolYear: outOfSchoolYear,
                                    isToday: isToday,
                                    class: evet.length > 0 ? evet[0].class : isToday ? 'isToday' : outOfSchoolYear ? 'disabled' : '',
                                    eventTitle: evet.length > 0 ? evet[0].eventTitle : ''
                                };
                            }
                            day++;
                        }

                        weeks.push(week);

                        firstWeekDay = ctrl.getNextMonday(firstWeekDay);
                    } while (firstWeekDay.getMonth() == month);

                    return weeks;

                    function areSameDay(d1, d2) {
                        return d1.getFullYear() == d2.getFullYear()
                            && d1.getMonth() == d2.getMonth()
                            && d1.getDate() == d2.getDate();
                    }
                };

                ctrl.calendar = {
                    monthName: months[startDate.getUTCMonth()],
                    year: startDate.getUTCFullYear(),
                    startDate: startDate,
                    endDate: new Date(startDate.getUTCFullYear(), startDate.getMonth() + 1, 0),
                    firstWeekDay: ctrl.getFirstDayOfWeek(startDate),
                    weeks: ctrl.getWeeks(startDate, scope.model.startDay, scope.model.stopDay)
                };


                ctrl.hasEvent = function (events, id) {
                    if (!events || events.length == 0) { return false; }
                    return events.some(e => e.attendanceEvent.id == id);
                }

                ctrl.getComments = function (events, ids) {
                    if (!events || events.length == 0) { return ''; }
                    return events
                        .filter(e => ids.some(eti => eti == e.attendanceEvent.id))
                        .reduce(function (accumulator, currentValue) {
                            return (accumulator != "" ? accumulator + ", \n" : "") +
                                `${currentValue.attendanceEvent.description}${currentValue.comments != null ? ': ' : ''}${currentValue.comments}`;
                        }, "");
                }
            }]
        };
    }]);