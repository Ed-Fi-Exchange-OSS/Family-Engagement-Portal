angular.module('app.directives')
    .component('studentCalendar', {
        bindings: {
            studentUsi: "<",
        }, // One way data binding.
        templateUrl: 'clientapp/modules/directives/studentCalendar/studentCalendar.view.html',
        controllerAs: 'ctrl',
        controller: ['api', function (api) {
            var ctrl = this;
            ctrl.model = {};
            ctrl.showLoader = false;
            var calendarEventAvailableColors = ['event-light-blue', 'event-orange', 'event-pink', 'event-purple', 'event-teal', 'event-green', 'event-brown', 'event-indigo', 'event-blue-grey', 'event-light-blue', 'event-orange', 'event-pink', 'event-purple', 'event-teal', 'event-green', 'event-brown', 'event-indigo', 'event-blue-grey'];
            var courses = [];

            var colorIndex = 0;

            ctrl.calendarEventColor = function (calendarEvent) {

                // Find the course in the courses array. 
                // If there then return that color as we want it to be the same.
                // If not assign a color and return it.
                var currentCourse = findCourseInArray(calendarEvent.courseTitle);

                if (currentCourse != null)
                    return currentCourse.color;

                // If no course then choose a color and save it to the array.
                var color = getAvailableColor();
                courses.push({ courseTitle: calendarEvent.courseTitle, color: color})
                return color;
            }

            function findCourseInArray(courseTitle) {
                for (var i = 0; i < courses.length; i++) {
                    if (courses[i].courseTitle == courseTitle)
                        return courses[i];
                }

                return null;
            }

            function getAvailableColor() {
                return calendarEventAvailableColors[courses.length];
            }


            ctrl.$onInit = function () {
                api.students.getStudentSchedule(ctrl.studentUsi).then(function (data) {
                    ctrl.model = data;
                    createPostionioning();
                    ctrl.showLoader = true;
                });
                    
            }

            function createPostionioning() {
                ctrl.model.days.forEach(function (day) {
                    day.events.forEach(function (event) {
                        timeToTopAndHeight(event);
                    });
                });
            }

            function timeToTopAndHeight(event) {
                var calendarHourHeight = 56;

                var startTimeDate = new Date(event.startTime);
                // Calculate Top
                // We use -7 beacuse the calendar starts at 7 am
                var topHours = (startTimeDate.getHours() - 7) * calendarHourHeight;
                var topMinutes = (startTimeDate.getMinutes()/60) * calendarHourHeight;
                event.top = topHours + topMinutes;

                // Calculate Height
                event.height = (event.durationInMinutes / 60) * calendarHourHeight;
            }

        }]
    });