import QtQuick 2.15
import QtQuick.Controls 2.15


Dialog {
    standardButtons: Dialog.Ok

    property alias listView: lv

    Text {
        id: title
        text: 'Earliest Deadline First Algorithm'
        font.pointSize: 20
        anchors.horizontalCenter: parent.horizontalCenter
    }

    ListView {
        id: lv
        x: 250
        width: 1000
        height: 500

        anchors {
            top: title.bottom
            topMargin: 20
        }

        model: ListModel {}

        delegate: Row {
            width: 300
            height: 100

            Text {
                y: 20
                text: 'Task ' + index
                font.pointSize: 20
            }

            Rectangle {
                height: 20
                width: 20
            }

            Column {
                Text {
                    text: 'Release Time'
                }
                SpinBox {
                    id: releaseTimeInput
                    value: releaseTime
                    onValueChanged: lv.model.get(index).releaseTime = value
                }
            }

            Rectangle {
                height: 20
                width: 20

            }

            Column {
                Text {
                    text: 'Deadline'
                }
                SpinBox {
                    id: dlInput
                    value: dl
                    to: periodInput.value
                    onValueChanged: lv.model.get(index).dl = value

                }
            }

            Rectangle {
                height: 20
                width: 20

            }

            Column {
                Text {
                    text: 'Execute Time'
                }
                SpinBox {
                    id: exeTimeInput
                    value: exeTime
                    to: dlInput.value
                    onValueChanged: {
                        lv.model.get(index).exeTime = value
                        uValue.value = u()
                    }
                }
            }

            Rectangle {
                height: 20
                width: 20

            }


            Column {
                Text {
                    text: 'Period'
                }
                SpinBox {
                    id: periodInput
                    value: period
                    onValueChanged: {
                        lv.model.get(index).period = value
                        uValue.value = u()
                    }

                }
            }


        }

    }

    Text {
        id: uValue
        x: 1100
        y: 200

        property real value
        text: 'U = ' + value
        color: value > 1 ? 'red' : 'black'

        visible: true
        font.pointSize: 20

    }

    function u() {
        let sum = 0
        for (let i = 0; i < lv.model.count; ++i) {
            let t = lv.model.get(i)
            sum += t.exeTime / t.period
        }
        return sum
    }
}
