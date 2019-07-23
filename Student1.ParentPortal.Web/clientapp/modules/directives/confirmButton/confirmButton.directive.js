angular.module('app.directives')
    .directive('confirmButton', ['$document', '$translate', function ($document, $translate) {
    return {
        restrict: 'A',
        scope: {
            confirmAction: '&confirmButton',
            placementCallback: '&'
        },
        link: function (scope, element, attrs) {
            var buttonId = Math.floor(Math.random() * 10000000000),
                yep = "Yes", //attrs.yes || "Yes",
                nope = "No", //attrs.no || "No",
                title = "Confirm delete", //attrs.title || "Confirm delete?",
                classes = attrs.classes || "text-center",
                placement = attrs.placement || "bottom";

            // Execute Translations
            yep = $translate.instant(yep);
            nope = $translate.instant(nope);
            title = $translate.instant(title) + '?';

            attrs.buttonId = buttonId;

            var html = "<div id=\"button-" + buttonId + "\" class=\"" + classes + "\">" +
                "<button type=\"button\" class=\"confirmbutton-yes btn btn-sm btn-danger m-r-10\">" + yep + "</button>" +
                "<button type=\"button\" class=\"confirmbutton-no btn btn-sm\">" + nope + "</button>" +
                "</div>";

            element.popover({
                content: html,
                html: true,
                trigger: "manual",
                title: title,
                placement: (angular.isDefined(attrs.placementCallback) ? scope.placementCallback() : placement)
            });

            element.bind('click', function (e) {
                var dontBubble = true;
                e.stopPropagation();

                if (element.attr("disabled")) return;

                element.popover('show');

                var pop = $("#button-" + buttonId);

                pop.closest(".popover").addClass('custom-popover').click(function (e) {
                    if (dontBubble) {
                        e.stopPropagation();
                    }
                });

                pop.find('.confirmbutton-yes').click(function (e) {
                    dontBubble = false;
                    element.popover('hide');
                    scope.$apply(scope.confirmAction);
                });

                pop.find('.confirmbutton-no').click(function (e) {
                    dontBubble = false;
                    $document.off('click.confirmbutton.' + buttonId);
                    element.popover('hide');
                });

                $document.on('click.confirmbutton.' + buttonId, ":not(.popover, .popover *)", function () {
                    $document.off('click.confirmbutton.' + buttonId);
                    element.popover('hide');
                });
            });
        }
    };
}]);