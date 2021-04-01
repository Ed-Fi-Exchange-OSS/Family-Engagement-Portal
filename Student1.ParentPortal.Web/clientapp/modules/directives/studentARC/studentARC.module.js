angular.module('app.directives')
    .component('studentARC', {
        bindings: {
            model: "<",
            link: '@'
        },
        templateUrl: 'clientapp/modules/directives/studentARC/studentARC.view.html',
        controllerAs: 'ctrl',
        controller: ['$scope', '$compile', function ($scope, $compile) {
            var ctrl = this;

            ctrl.showIRLA = true;
            ctrl.showENIL = true;

            ctrl.arcModelIRLA = {
                reportingDate: null,
                rlBaseLine: '',
                rlCurrent: '',
                powerGoal: '',
                currentDaysOnGoal: '',
                baselineDate: '',
                scoreValue: null,
                graphicLayout: {
                    master: '',
                    levels: 0,
                    levelsName: [],
                    currentPosition: 0
                }
            };

            ctrl.arcModelENIL = {
                reportingDate: null,
                rlBaseLine: '',
                rlCurrent: '',
                powerGoal: '',
                currentDaysOnGoal: '',
                baselineDate: '',
                scoreValue: null,
                graphicLayout: {
                    master: '',
                    levels: 0,
                    levelsName: [],
                    currentPosition: 0
                }
            };

            ctrl.masterLayoutInformationIRLA = [
                {
                    levelName: 'RTM',
                    master: 'PreK',
                    numberOfLevels: 1,
                    position: 0,
                    text: 'Read-Aloud Immersion',
                    begin: 0,
                    end: 0,
                    index: 0
                },
                {
                    levelName: '1-3Y',
                    master: 'Kindergarten',
                    numberOfLevels: 2,
                    position: 0,
                    text: 'Active Reading Strategies and Initial Consonants',
                    begin: 0.01,
                    end: 0.59,
                    index: 1
                },
                {
                    levelName: '1G',
                    master: 'Kindergarten',
                    numberOfLevels: 2,
                    position: 1,
                    text: 'High-Frequency Words',
                    begin: 0.60,
                    end: 0.99,
                    index: 1
                },
                {
                    levelName: '2G',
                    master: '1',
                    numberOfLevels: 3,
                    position: 0,
                    text: 'Initial Blends and Digraphs',
                    begin: 1,
                    end: 1.29,
                    index: 2
                },
                {
                    levelName: '1B',
                    master: '1',
                    numberOfLevels: 3,
                    position: 1,
                    text: 'Onset+ Sight Word/Rime',
                    begin: 1.30,
                    end: 1.59,
                    index: 2
                },
                {
                    levelName: '2B',
                    master: '1',
                    numberOfLevels: 3,
                    position: 2,
                    text: '2-Syllable Words',
                    begin: 1.60,
                    end: 1.99,
                    index: 2
                },
                {
                    levelName: '1R',
                    master: '2',
                    numberOfLevels: 2,
                    position: 0,
                    text: 'Multisyllabic Words',
                    begin: 2,
                    end: 2.49,
                    index: 3
                },
                {
                    levelName: '2R',
                    master: '2',
                    numberOfLevels: 2,
                    position: 1,
                    text: 'Irregularly Spelled Words and Chapter Books',
                    begin: 2.5,
                    end: 2.99,
                    index: 3
                },
                {
                    levelName: 'Wt',
                    master: '3',
                    numberOfLevels: 1,
                    position: 0,
                    text: 'Tier II Vocabulary in Context',
                    begin: 3,
                    end: 3.99,
                    index: 4
                },
                {
                    levelName: 'Bk',
                    master: '4',
                    numberOfLevels: 1,
                    position: 0,
                    text: 'Academic Vocabulary of 1,500+ Tier II/III Words and Series Habit',
                    begin: 4,
                    end: 4.99,
                    index: 5
                },
                {
                    levelName: 'Or',
                    master: '5',
                    numberOfLevels: 1,
                    position: 0,
                    text: 'Latin and Greek Roots and Genre Expansion',
                    begin: 5,
                    end: 5.99,
                    index: 6
                },
                {
                    levelName: 'Pu',
                    master: '6',
                    numberOfLevels: 1,
                    position: 0,
                    text: 'Genre Expansion',
                    begin: 6,
                    end: 6.99,
                    index: 7
                },
                {
                    levelName: '1Br',
                    master: '7',
                    numberOfLevels: 1,
                    position: 0,
                    text: "Author's Craft, Point of View, Bias",
                    begin: 7,
                    end: 7.99,
                    index: 8
                },
                {
                    levelName: '2Br',
                    master: '8',
                    numberOfLevels: 1,
                    position: 0,
                    text: "Author's Craft, Point of View, Bias",
                    begin: 7,
                    end: 8.99,
                    index: 9
                },
                {
                    levelName: 'Si',
                    master: '9 & 10',
                    numberOfLevels: 1,
                    position: 0,
                    text: 'Literary Analysis',
                    begin: 9,
                    end: 10.99,
                    index: 10
                },
                {
                    levelName: 'GI',
                    master: '11 & 12',
                    numberOfLevels: 1,
                    position: 0,
                    text: 'College and Career Ready',
                    begin: 11,
                    end: 12.99,
                    index: 11
                }
            ];

            ctrl.masterLayoutInformationENIL = [
                {
                    levelName: 'LAM',
                    master: 'PreK',
                    numberOfLevels: 1,
                    position: 0,
                    text: 'Read-Aloud Immersion',
                    begin: 0,
                    end: 0,
                    index: 0
                },
                {
                    levelName: '1-3A',
                    master: 'Kindergarten',
                    numberOfLevels: 2,
                    position: 0,
                    text: 'Active Reading Strategies  Initial Letters/Syllables',
                    begin: 0.01,
                    end: 0.59,
                    index: 1
                },
                {
                    levelName: '1V',
                    master: 'Kindergarten',
                    numberOfLevels: 2,
                    position: 1,
                    text: 'Simple Two-Syllable Words',
                    begin: 0.6,
                    end: 0.99,
                    index: 1
                },
                {
                    levelName: '2V',
                    master: '1',
                    numberOfLevels: 3,
                    position: 0,
                    text: 'Any Familiar Two-Syllable Word',
                    begin: 1,
                    end: 1.29,
                    index: 2
                },
                {
                    levelName: '1Az',
                    master: '1',
                    numberOfLevels: 3,
                    position: 1,
                    text: 'Three-Syllable Words',
                    begin: 1.30,
                    end: 1.59,
                    index: 2
                },
                {
                    levelName: '2Az',
                    master: '1',
                    numberOfLevels: 3,
                    position: 2,
                    text: 'Four-Syllable Words',
                    begin: 1.6,
                    end: 1.99,
                    index: 2
                },
                {
                    levelName: '1R',
                    master: '2',
                    numberOfLevels: 2,
                    position: 0,
                    text: 'Multisyllabic Words',
                    begin: 2,
                    end: 2.49,
                    index: 3
                },
                {
                    levelName: '2R',
                    master: '2',
                    numberOfLevels: 2,
                    position: 1,
                    text: 'Decode All Kinds of Words and Chapter Books',
                    begin: 2.5,
                    end: 2.99,
                    index: 3
                },
                {
                    levelName: 'BI',
                    master: '3',
                    numberOfLevels: 1,
                    position: 0,
                    text: 'Tier II Vocabulary in Context',
                    begin: 3,
                    end: 3.99,
                    index: 4
                },
                {
                    levelName: 'Ne',
                    master: '4',
                    numberOfLevels: 1,
                    position: 0,
                    text: 'Academic Vocabulary of 1,500+Tier II/III Words and Series Habit',
                    begin: 4,
                    end: 4.99,
                    index: 5
                },
                {
                    levelName: 'An',
                    master: '5',
                    numberOfLevels: 1,
                    position: 0,
                    text: 'Latin and Greek Roots and Genre Expansion',
                    begin: 5,
                    end: 5.99,
                    index: 6
                },
                {
                    levelName: 'Pu',
                    master: '6',
                    numberOfLevels: 1,
                    position: 0,
                    text: 'Genre Expansion',
                    begin: 6,
                    end: 6.99,
                    index: 7
                },
                {
                    levelName: '1Br',
                    master: '7',
                    numberOfLevels: 1,
                    position: 0,
                    text: "Author's Craft, Point of View, Bias",
                    begin: 7,
                    end: 7.99,
                    index: 8
                },
                {
                    levelName: '2Br',
                    master: '8',
                    numberOfLevels: 1,
                    position: 0,
                    text: "Author's Craft, Point of View, Bias",
                    begin: 8,
                    end: 8.99,
                    index: 9
                },
                {
                    levelName: 'PI',
                    master: '9 & 10',
                    numberOfLevels: 1,
                    position: 0,
                    text: 'Literary Analysis',
                    begin: 9,
                    end: 10.99,
                    index: 10
                },
                {
                    levelName: 'Or',
                    master: '11 & 12',
                    numberOfLevels: 1,
                    position: 0,
                    text: 'College and Career Ready',
                    begin: 11,
                    end: 12.99,
                    index: 11
                }
            ];

            ctrl.grades = ['Preschool/Prekindergarten', 'Kindergarten', 'First grade', 'Second grade', 'Third grade', 'Fourth grade', 'Fifth grade', 'Sixth grade', 'Seventh grade', 'Eighth grade', 'Ninth grade|Tenth grade', 'Eleventh grade|Twelfth grade'];

            ctrl.$onInit = function () {

                ctrl.setData();
            };
            ctrl.$onChanges = function (changes) {
                ctrl.setData();
            }
            ctrl.setData = function () {
                //console.log("ARC::", ctrl.model.assessment);
                if (ctrl.model === undefined)
                    return;
                for (let i = 0; i < ctrl.model.length; i++) {

                    let record = ctrl.model[i];

                    if (record.title.indexOf('ENIL') >= 0) {

                        record.objectiveAssessments.forEach(element => {
                            if (element.identificationCode == 'ARC Reading Level (Baseline)') {
                                this.arcModelENIL.rlBaseLine = element.englishResult;
                            }
                            else if (element.identificationCode == 'ARC Reading Level') {
                                this.arcModelENIL.reportingDate = element.englishResult;
                                this.arcModelENIL.rlCurrent = element.englishResult;
                            }
                            else if (element.identificationCode == 'ARC Power Goal Abbreviation') {
                                this.arcModelENIL.powerGoal = element.englishResult;
                            }
                            else if (element.identificationCode == 'ARC Days on Current Power Goal') {
                                this.arcModelENIL.currentDaysOnGoal = element.englishResult;
                            }
                            else if (element.identificationCode == 'ARC Baseline Reporting Date') {
                                this.arcModelENIL.baselineDate = element.englishResult;
                            }
                            else if (element.identificationCode == 'ARC Score') {
                                this.arcModelENIL.scoreValue = element.englishResult;
                            }
                        });
                    }
                    else if (record.title.indexOf('IRLA') >= 0) {
                        record.objectiveAssessments.forEach(element => {

                            if (element.identificationCode == 'ARC Reading Level (Baseline)') {
                                this.arcModelIRLA.rlBaseLine = element.englishResult;
                            }
                            else if (element.identificationCode == 'ARC Reading Level') {
                                this.arcModelIRLA.reportingDate = element.administrationDate;
                                this.arcModelIRLA.rlCurrent = element.englishResult;
                            }
                            else if (element.identificationCode == 'ARC Power Goal Abbreviation') {
                                this.arcModelIRLA.powerGoal = element.englishResult;
                            }
                            else if (element.identificationCode == 'ARC Days on Current Power Goal') {
                                this.arcModelIRLA.currentDaysOnGoal = element.englishResult;
                            }
                            else if (element.identificationCode == 'ARC Baseline Reporting Date') {
                                this.arcModelIRLA.baselineDate = element.englishResult;
                            }
                            else if (element.identificationCode == 'ARC Score') {
                                this.arcModelIRLA.scoreValue = element.englishResult;
                            }

                        });

                    }
                }


                if (ctrl.arcModelIRLA.rlCurrent != '-') {
                    for (let i = 0; i < ctrl.masterLayoutInformationIRLA.length; i++) {
                        let record = ctrl.masterLayoutInformationIRLA[i];
                        if (record.levelName == ctrl.arcModelIRLA.rlCurrent) {
                            ctrl.arcModelIRLA.graphicLayout.master = record.master;
                            ctrl.arcModelIRLA.graphicLayout.levels = record.numberOfLevels;
                            ctrl.arcModelIRLA.graphicLayout.currentPosition = record.position;
                        }
                    }

                    for (let i = 0; i < ctrl.masterLayoutInformationIRLA.length; i++) {
                        let record = ctrl.masterLayoutInformationIRLA[i];
                        if (record.master == ctrl.arcModelIRLA.graphicLayout.master) {
                            ctrl.arcModelIRLA.graphicLayout.levelsName.push(record.levelName);
                        }
                    }
                }

                if (ctrl.arcModelENIL.rlCurrent != '-') {
                    for (let i = 0; i < ctrl.masterLayoutInformationENIL.length; i++) {
                        let record = ctrl.masterLayoutInformationENIL[i];
                        if (record.levelName == ctrl.arcModelENIL.rlCurrent) {
                            ctrl.arcModelENIL.graphicLayout.master = record.master;
                            ctrl.arcModelENIL.graphicLayout.levels = record.numberOfLevels;
                            ctrl.arcModelENIL.graphicLayout.currentPosition = record.position;
                        }
                    }

                    for (let i = 0; i < ctrl.masterLayoutInformationENIL.length; i++) {
                        let record = ctrl.masterLayoutInformationENIL[i];
                        if (record.master == ctrl.arcModelENIL.graphicLayout.master) {
                            ctrl.arcModelENIL.graphicLayout.levelsName.push(record.levelName);
                        }
                    }
                }

                if (ctrl.arcModelIRLA.rlBaseLine == '1Y' || ctrl.arcModelIRLA.rlBaseLine == '2Y' || ctrl.arcModelIRLA.rlBaseLine == '3Y') {
                    ctrl.arcModelIRLA.rlBaseLine = '1-3Y';
                }

                if (ctrl.arcModelIRLA.rlCurrent == '1Y' || ctrl.arcModelIRLA.rlCurrent == '2Y' || ctrl.arcModelIRLA.rlCurrent == '3Y') {
                    ctrl.arcModelIRLA.rlCurrent = '1-3Y';
                }

                if (ctrl.arcModelENIL.rlBaseLine == '1A' || ctrl.arcModelENIL.rlBaseLine == '2A' || ctrl.arcModelENIL.rlBaseLine == '3A') {
                    ctrl.arcModelENIL.rlBaseLine = '1-3A';
                }

                if (ctrl.arcModelENIL.rlCurrent == '1A' || ctrl.arcModelENIL.rlCurrent == '2A' || ctrl.arcModelENIL.rlCurrent == '3A') {
                    ctrl.arcModelENIL.rlCurrent = '1-3A';
                }

                //IRLA information
                if (ctrl.arcModelIRLA.rlBaseLine != null && ctrl.arcModelIRLA.rlBaseLine != '' && ctrl.arcModelIRLA.rlBaseLine != '-') {
                    for (var i = 0; i < ctrl.masterLayoutInformationIRLA.length; i++) {
                        var irlaItem = ctrl.masterLayoutInformationIRLA[i];
                        if (irlaItem.levelName == ctrl.arcModelIRLA.rlBaseLine) {
                            var elementId = 'Itd' + irlaItem.levelName;
                            var htmlelement = document.getElementById(elementId);
                            var htmlelementSize = htmlelement.clientWidth;
                            var position = (htmlelementSize / 2) - 24;
                            var positionText = -65 + position;
                            var $marker1 = $("<div tooltip-placement='top' uib-tooltip='Current Year Baseline' style='background-color:deepskyblue;margin-left:" + position + "px' class='pin1'></div>");
                            var $marker2 = $("<div class='pinText1' style='margin-top:20px;margin-left:" + positionText + "px'>Current <br/> Year Baseline</div>");
                            $compile($marker1)($scope);
                            $marker1.appendTo(htmlelement);
                            $compile($marker2)($scope);
                            $marker2.appendTo(htmlelement);
                        }
                    }
                }

                if (ctrl.arcModelIRLA.rlCurrent != null && ctrl.arcModelIRLA.rlCurrent != '' && ctrl.arcModelIRLA.rlCurrent != '-') {
                    for (var i = 0; i < ctrl.masterLayoutInformationIRLA.length; i++) {
                        var irlaItem = ctrl.masterLayoutInformationIRLA[i];
                        if (irlaItem.levelName == ctrl.arcModelIRLA.rlCurrent) {
                            var elementId = 'Itd' + irlaItem.levelName;
                            var htmlelement = document.getElementById(elementId);
                            var htmlelementSize = htmlelement.clientWidth;
                            var position = 0;
                            if (ctrl.arcModelIRLA.scoreValue >= irlaItem.begin && ctrl.arcModelIRLA.scoreValue <= irlaItem.end) {
                                var result1 = ctrl.arcModelIRLA.scoreValue - irlaItem.begin;
                                if (result1 > 0) {
                                    var result2 = (result1 * 100) / (irlaItem.end - irlaItem.begin);
                                    var result3 = (result2 * htmlelementSize) / 100;
                                    position = result3 - 24;
                                }
                                else {
                                    position = -23;
                                }
                            }
                            else {
                                position = -23;
                            }
                            var positionText = -27 + position;
                            //ctrl.addElementInView(elementId, "", "");
                            var $marker1 = $("<div tooltip-placement='top' uib-tooltip='Current Days on goal: " + ctrl.arcModelIRLA.currentDaysOnGoal + "' style='background-color:lightgreen;margin-left:" + position + "px' class='pin1'></div>");
                            var $marker2 = $("<div class='pinText1' style='margin-left:" + positionText + "px'>Current <br /> Days on goal: " + ctrl.arcModelIRLA.currentDaysOnGoal + "</div>");
                            $compile($marker1)($scope);
                            $marker1.appendTo(htmlelement);
                            $compile($marker2)($scope);
                            $marker2.appendTo(htmlelement);
                        }
                    }
                }

                //ENIL information
                if (ctrl.arcModelENIL.rlBaseLine != null && ctrl.arcModelENIL.rlBaseLine != '' && ctrl.arcModelENIL.rlBaseLine != '-') {
                    for (var i = 0; i < ctrl.masterLayoutInformationENIL.length; i++) {
                        var irlaItem = ctrl.masterLayoutInformationENIL[i];
                        if (irlaItem.levelName == ctrl.arcModelENIL.rlBaseLine) {
                            var elementId = 'Etd' + irlaItem.levelName;
                            var htmlelement = document.getElementById(elementId);
                            var htmlelementSize = htmlelement.clientWidth;
                            var position = (htmlelementSize / 2) - 24;
                            var positionText = -65 + position;
                            var $marker1 = $("<div tooltip-placement='top' uib-tooltip='Current Year Baseline' style='background-color:deepskyblue;margin-left:" + position + "px' class='pin1'></div>");
                            var $marker2 = $("<div class='pinText1' style='margin-top:20px;margin-left:" + positionText + "px'>Current <br/> Year Baseline</div>");
                            $compile($marker1)($scope);
                            $marker1.appendTo(htmlelement);
                            $compile($marker2)($scope);
                            $marker2.appendTo(htmlelement);
                        }
                    }
                }

                if (ctrl.arcModelENIL.rlCurrent != null && ctrl.arcModelENIL.rlCurrent != '' && ctrl.arcModelENIL.rlCurrent != '-') {
                    for (var i = 0; i < ctrl.masterLayoutInformationENIL.length; i++) {
                        var irlaItem = ctrl.masterLayoutInformationENIL[i];
                        if (irlaItem.levelName == ctrl.arcModelENIL.rlCurrent) {
                            var elementId = 'Etd' + irlaItem.levelName;
                            var htmlelement = document.getElementById(elementId);
                            var htmlelementSize = htmlelement.clientWidth;
                            var position = 0;
                            if (ctrl.arcModelENIL.scoreValue >= irlaItem.begin && ctrl.arcModelENIL.scoreValue <= irlaItem.end) {
                                var result1 = ctrl.arcModelENIL.scoreValue - irlaItem.begin;
                                if (result1 > 0) {
                                    var result2 = (result1 * 100) / (irlaItem.end - irlaItem.begin);
                                    var result3 = (result2 * htmlelementSize) / 100;
                                    position = result3 - 24;
                                }
                                else {
                                    position = -23;
                                }
                            }
                            else {
                                position = -23;
                            }
                            var positionText = -27 + position;
                            var $marker1 = $("<div tooltip-placement='top' uib-tooltip='Current Days on goal: " + ctrl.arcModelENIL.currentDaysOnGoal + "' style='background-color:lightgreen;margin-left:" + position + "px' class='pin1'></div>");
                            var $marker2 = $("<div class='pinText1' style='margin-left:" + positionText + "px'>Current <br /> Days on goal: " + ctrl.arcModelENIL.currentDaysOnGoal + "</div>");
                            $compile($marker1)($scope);
                            $marker1.appendTo(htmlelement);
                            $compile($marker2)($scope);
                            $marker2.appendTo(htmlelement);
                        }
                    }
                }

                //IRLA AND ENIL Target
                if (ctrl.model.gradeLevel != null && ctrl.model.gradeLevel != '') {
                    for (var i = 0; i < ctrl.grades.length; i++) {
                        var item = ctrl.grades[i];
                        if (item.indexOf(ctrl.model.gradeLevel) >= 0) {
                            var indexTarget = null;
                            for (var j = 0; j < ctrl.masterLayoutInformationIRLA.length; j++) {
                                if (ctrl.masterLayoutInformationIRLA[j].index == i) {
                                    indexTarget = ctrl.masterLayoutInformationIRLA[j].levelName;
                                }
                            }
                            if (indexTarget != null) {
                                var elementId = 'Itd' + indexTarget;
                                var htmlelement = document.getElementById(elementId);
                                var htmlelementSize = htmlelement.clientWidth;
                                var position = htmlelementSize - 26;
                                var $marker1 = $("<div tooltip-placement='top' uib-tooltip='Target' style='background-color:#D8D8D8;margin-left:" + position + "px' class='pin1'></div>");
                                var $marker2 = $("<div class='pinText1' style='margin-left:" + (-8 + position) + "px'>Target</div>");
                                $compile($marker1)($scope);
                                $marker1.appendTo(htmlelement);
                                $compile($marker2)($scope);
                                $marker2.appendTo(htmlelement);
                            }
                        }
                    }

                    for (var i = 0; i < ctrl.grades.length; i++) {
                        var item = ctrl.grades[i];
                        if (item.indexOf(ctrl.model.gradeLevel) >= 0) {
                            var indexTarget = null;
                            for (var j = 0; j < ctrl.masterLayoutInformationENIL.length; j++) {
                                if (ctrl.masterLayoutInformationENIL[j].index == i) {
                                    indexTarget = ctrl.masterLayoutInformationENIL[j].levelName;
                                }
                            }
                            if (indexTarget != null) {
                                var elementId = 'Etd' + indexTarget;
                                var htmlelement = document.getElementById(elementId);
                                var htmlelementSize = htmlelement.clientWidth;
                                var position = htmlelementSize - 26;
                                var $marker1 = $("<div tooltip-placement='top' uib-tooltip='Target' style='background-color:#D8D8D8;margin-left:" + position + "px' class='pin1'></div>");
                                var $marker2 = $("<div class='pinText1' style='margin-left:" + (-8 + position) + "px'>Target</div>");
                                $compile($marker1)($scope);
                                $marker1.appendTo(htmlelement);
                                $compile($marker2)($scope);
                                $marker2.appendTo(htmlelement);
                            }
                        }
                    }
                }

                //show/hide if information does not exist

                //if (ctrl.arcModelIRLA.rlCurrent == null || ctrl.arcModelIRLA.rlCurrent == '' || ctrl.arcModelIRLA.rlCurrent == '-') {
                //    ctrl.showIRLA = false;
                //}

                //if (ctrl.arcModelENIL.rlCurrent == null || ctrl.arcModelENIL.rlCurrent == '' || ctrl.arcModelENIL.rlCurrent == '-') {
                //    ctrl.showENIL = false;
                //}

                if (!ctrl.showIRLA && !ctrl.showENIL) {
                    $scope.$emit('studentARC', false);
                }
            }
            ctrl.addElementInView = function (idTarget, elementMarker, elementText) {
                var htmlelement = document.getElementById(idTarget);
                var elementBaseLine = angular.element(elementMarker);
                var elementBaseLineText = angular.element(elementText);
                angular.element(htmlelement).append(elementBaseLine);
                angular.element(htmlelement).append(elementBaseLineText);
            };

        }]
    });
