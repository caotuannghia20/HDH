import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15

Window {
    id: app
    width: 1700
    height: 500
    visible: true
    title: 'Earliest Deadline First Algorithm'

    property var demoTasks: [
        { releaseTime: 0, dl: 4, exeTime: 1, period: 4, color: 'red' },
        { releaseTime: 0, dl: 6, exeTime: 2, period: 6, color: 'blue' },
        { releaseTime: 0, dl: 8, exeTime: 3, period: 8, color: 'green' },
        { releaseTime: 0, dl: 25, exeTime: 1, period: 25, color: 'yellow' },
    ]

    property var tasks: []
    property int current: 0
    property real time: 0


    TaskCountDialog {
        id: taskCountDialog
        anchors.centerIn: parent

        onAccepted: {
            for (let i = 0; i < value; ++i) {
                dataInput.listView.model.append(demoTasks[i])
            }
            dataInput.visible = true
        }
    }

    TaskInfoDialog {
        id: dataInput

        width: parent.width
        height: parent.height
        visible: false

        onAccepted: {
            for (let i = 0; i < listView.model.count; ++i) {
                let t = listView.model.get(i)
                tasks.push({
                   id: i,
                   releaseTime: t.releaseTime,
                   dl: t.dl,
                   exeTime: t.exeTime,
                   period: t.period,
                   nextDl: t.releaseTime + t.dl,
                   remainTime: 0,
                   color: t.color,
               })
            }
            loader.sourceComponent = main
        }
    }



    Loader {
        id: loader
        anchors.fill: parent
    }

    Component {
        id: main

        Item {
            anchors.fill: parent

            Text {
               id: title
               height: 100
               text: 'Earliest Deadline First Algorithm'
               font.pointSize: 20
               anchors.horizontalCenter: parent.horizontalCenter
            }

            ListView {
                id: taskNames
                model: 4
                x: 50
                width: 100
                height: 400
                anchors.top: title.bottom

                delegate: Text {
                    font.pointSize: 20
                    height: 50
                    text: 'Task ' + tasks[index].id
                }
            }

            ListView {
                id: diagram
                width: 1500

                anchors {
                    top: title.bottom
                    left: taskNames.right
                }

                orientation: Qt.Horizontal
                model: ListModel {}

                delegate: Item {
                    width: 50
                    height: 50

                    Rectangle {
                        y: yy
                        width: 50
                        height: 50
                        color: c
                    }

                }

                GridView {
                    model: 30
                    cellWidth: 50
                    cellHeight: 50
                    anchors.fill: parent

                    delegate: Item {
                        width: 50
                        height: 200

                        Rectangle {
                            anchors.fill: parent
                            opacity: 0.1
                            border {
                                color: 'black'
                                width: 1
                            }
                        }

                        Rectangle {
                            property int i: 0
                            y: i * 50
                            opacity: op(index, i)
                            anchors.left: parent.left
                            width: 2 * opacity
                            height: 50 * opacity
                            color: i < tasks.length ? tasks[i].color : ''
                        }

                        Rectangle {
                            property int i: 1
                            y: i * 50
                            anchors.left: parent.left
                            opacity: op(index, i)
                            width: 2 * opacity
                            height: 50 * opacity
                            color: i < tasks.length ? tasks[i].color : ''
                        }

                        Rectangle {
                            property int i: 2
                            y: i * 50
                            anchors.left: parent.left
                            opacity: op(index, i)
                            width: 2 * opacity
                            height: 50 * opacity
                            color: i < tasks.length ? tasks[i].color : ''
                        }

                        Rectangle {
                            property int i: 3
                            y: i * 50
                            anchors.left: parent.left
                            opacity: op(index, i)
                            width: 2 * opacity
                            height: 50 * opacity
                            color: i < tasks.length ? tasks[i].color : ''
                        }

                        Text {
                            y: 200
                            text: index
                        }

                        function op(c, idx) {
                            if (idx >= tasks.length)
                                return 0

                            let offset = c - tasks[idx].releaseTime

                            if (offset < 0)
                                return 0

                            if (offset % tasks[idx].period === 0)
                                return 1

                            if (offset % tasks[idx].period === tasks[idx].dl)
                                return 0.5

                            return 0
                        }
                    }
                }


            }

            Queue {
                id: readyQueue
                x: 500
                y: 350

                title: 'Ready queue'
                time: app.time
                tasks: app.tasks
                condition: index => tasks[index].remainTime === tasks[index].exeTime
            }

            Queue {
                id: runningQueue
                x: 500
                y: 420

                title: 'Running queue'
                time: app.time
                tasks: app.tasks
                condition: index => tasks[index].remainTime > 0 && tasks[index].remainTime < tasks[index].exeTime
            }



            Timer {
                id: timer
                interval: 1000
                running: true
                repeat: true

                onTriggered: {
                    console.log('----------' + time + '-------------')

                    for (let t of tasks) {
                        let offset = time - t.releaseTime

                        if (offset >= 0 && offset % t.period === 0) {
                            if (t.remainTime > 0)
                                dlFailed.text += 'Task ' + t.id + ' failed deadline at ' + time + '\n'

                            t.remainTime += t.exeTime
                        }

                        console.log('Task ' + t.id + ' - Remain: ' + t.remainTime)
                    }

                    current = nextDeadline()

                    if (current == -1) {
                        diagram.model.append({ yy: 50, c: 'white' })
                        ++time
                        return
                    }

                    let currentTask = tasks[current]
                    diagram.model.append({ yy: 50 * current, c: currentTask.color })

                    --currentTask.remainTime


                    if (currentTask.remainTime === 0) {
                        currentTask.nextDl += currentTask.period
                    }

                    time += 1

                    if (time == 30)
                        running = false
                }
            }


            Text {
                id: dlFailed
                x: 100
                y: 350
            }

            Button {
                x: 1200
                y: 400
                width: 100
                height: 50
                text: 'Speed up'
                onClicked: timer.interval = 100
            }

            Button {
                id: pauseBtn
                x: 1400
                y: 400
                width: 100
                height: 50

                property bool paused: false

                text: paused ? 'Continue' : 'Pause'
                onClicked: {
                    paused = !paused
                    timer.running = !paused
                }
            }
        }



    }






    function nextDeadline() {
        let min = 999
        let index = -1

        for (let t of tasks) {
            if (time < t.releaseTime)
                continue

            if (t.remainTime > 0 && t.nextDl < min) {
                min = t.nextDl
                index = t.id
            }

        }

        if (index == -1)
            return -1

        if (current != -1) {
            let currentTask = tasks[current]
            if (currentTask.nextDl === tasks[index].nextDl && currentTask.remainTime > 0)
                return current
        }

        return index
    }

    Component.onCompleted: {
        taskCountDialog.open()
    }
}
