import QtQuick 2.0
import QtQuick.Layouts 1.1
import org.kde.plasma.plasmoid 2.0
import org.kde.plasma.core 2.0 as PlasmaCore

import "lib"

Item {
	id: widget
    
    // Updater 1/3 ==================================================================================================================================
    property string updateResponse;
    property string currentVersion: '6.0';
    property bool checkUpdateStartup: Plasmoid.configuration.checkUpdateStartup
    // ==============================================================================================================================================

	property bool disableLatteParabolicIcon: true // Don't hide the representation in Latte (https://github.com/psifidotos/Latte-Dock/issues/983)
    
    property var plasmascript: ''
    property var plasmascriptline1: ''
    property var plasmascriptlinex: ''
    property var plasmascriptliney: ''
    property var plasmascriptlinez: ''
    property var plasmascriptline2: ''
    property var plasmascriptline3: ''
    property var plasmascriptline4: ''
    property var plasmascriptline5: ''
    property var plasmascriptline6: ''
    property var switchPanelMain: plasmoid.configuration.clickCommandID
    property var switchPanelSwitch: plasmoid.configuration.clickCommandID2
    property var script: "setImmutability('mutable');"
    property var unlockHacky1: 'qdbus org.kde.kglobalaccel /component/plasmashell invokeShortcut "show dashboard"; '
    property var unlockHacky2: 'xdotool key alt+d l; qdbus org.kde.kglobalaccel /component/plasmashell invokeShortcut "show dashboard"'
    property var advancedScript_p1: 'qdbus org.kde.plasmashell /PlasmaShell org.kde.PlasmaShell.evaluateScript '
    property var advancedScript_p2: "setImmutability('userImmutable');"
    property var manualHide: 'False'
    property var manualShow: 'False'
    property var switchAction: 'True'
    property var panelIdToIntStr: ''
    property var panelIdToIntStrSwitch: ''

	Plasmoid.onActivated: widget.activate()
    
	Plasmoid.preferredRepresentation: Plasmoid.fullRepresentation
	Plasmoid.fullRepresentation: Item {
		id: panelItem

		readonly property bool inPanel: (plasmoid.location == PlasmaCore.Types.TopEdge
			|| plasmoid.location == PlasmaCore.Types.RightEdge
			|| plasmoid.location == PlasmaCore.Types.BottomEdge
			|| plasmoid.location == PlasmaCore.Types.LeftEdge)

		Layout.minimumWidth: {
			switch (plasmoid.formFactor) {
			case PlasmaCore.Types.Vertical:
				return 0;
			case PlasmaCore.Types.Horizontal:
				return height;
			default:
				return units.gridUnit * 3;
			}
		}

		Layout.minimumHeight: {
			switch (plasmoid.formFactor) {
			case PlasmaCore.Types.Vertical:
				return width;
			case PlasmaCore.Types.Horizontal:
				return 0;
			default:
				return units.gridUnit * 3;
			}
		}

		Layout.maximumWidth: inPanel ? units.iconSizeHints.panel : -1
		Layout.maximumHeight: inPanel ? units.iconSizeHints.panel : -1

		AppletIcon {
			id: icon
			anchors.fill: parent

			source: plasmoid.configuration.icon
			active: mouseArea.containsMouse
		}

		MouseArea {
			id: mouseArea
			anchors.fill: parent
			hoverEnabled: true
			onClicked: widget.activate()
		}
	}
    
	PlasmaCore.DataSource {
		id: executable
		engine: "executable"
		connectedSources: []
		onNewData: disconnectSource(sourceName)

		function exec(cmd) {
			executable.connectSource(cmd)
		}
	}
    
    function action_panelIdToIntString() {
        //panelIdToIntStr --------------------------
        if (switchPanelMain == 'PanelID0') {
            panelIdToIntStr = "0";
        }
        if (switchPanelMain == 'PanelID1') {
            panelIdToIntStr = "1";
        }
        if (switchPanelMain == 'PanelID2') {
            panelIdToIntStr = "2";
        }
        if (switchPanelMain == 'PanelID3') {
            panelIdToIntStr = "3";
        }
        if (switchPanelMain == 'PanelID4') {
            panelIdToIntStr = "4";
        }
        if (switchPanelMain == 'PanelID5') {
            panelIdToIntStr = "5";
        }
        if (switchPanelMain == 'PanelID6') {
            panelIdToIntStr = "6";
        }
        //------------------------------------------
        
        //panelIdToIntStrSwitch --------------------
        if (switchPanelSwitch == 'PanelID0') {
            panelIdToIntStrSwitch = "0";
        }
        if (switchPanelSwitch == 'PanelID1') {
            panelIdToIntStrSwitch = "1";
        }
        if (switchPanelSwitch == 'PanelID2') {
            panelIdToIntStrSwitch = "2";
        }
        if (switchPanelSwitch == 'PanelID3') {
            panelIdToIntStrSwitch = "3";
        }
        if (switchPanelSwitch == 'PanelID4') {
            panelIdToIntStrSwitch = "4";
        }
        if (switchPanelSwitch == 'PanelID5') {
            panelIdToIntStrSwitch = "5";
        }
        if (switchPanelSwitch == 'PanelID6') {
            panelIdToIntStrSwitch = "6";
        }
        //------------------------------------------
    }
    
	function action_prepareScript() {
        //manualHide //manualShow //switchAction

        action_panelIdToIntString();
        
        if (plasmoid.configuration.forceSize == 'True') {
        
            plasmascriptline2 = "if (panel.height == -1) {panel.height = " + plasmoid.configuration.customSize + "} else {panel.height = -1;} ";
            
            if (manualHide == 'True') {
                plasmascriptline2 = "if (panel.height > 0) {panel.height = -1;} ";
            }
            
            if (manualShow == 'True') {
                plasmascriptline2 = "if (panel.height == -1) {panel.height = " + plasmoid.configuration.customSize + "} ";
            }
            
            //panel2
            if (switchAction == 'True') {                
                plasmascriptlinex = "if (panel.height < 0) {state1 = 'False';} if (panel2.height < 0) {state2 = 'False';} ";
                plasmascriptline2 = "if (panel.height == -1) {panel.height = " + plasmoid.configuration.customSize + "} else {panel.height = -1;} ";
                plasmascriptlinez = "if (panel2.height == -1) {panel2.height = " + plasmoid.configuration.customSize + "} else {panel2.height = -1;} ";
                plasmascriptliney = "if (state2 != state1) {" + plasmascriptlinez + "} ";
            } else {
                plasmascriptlinex = "";
                plasmascriptliney = "";
                plasmascriptlinez = "";
            }
            
            //Attention need to leave panel vat set to the visible one \/
            //Not implemented feature grayed
            
        } else {
        
            plasmascriptline2 = "panel.height = panel.height * -1; ";
            
            if (manualHide == 'True') {
                plasmascriptline2 = "if (panel.height > 0) {panel.height = panel.height * -1;} ";
            }
            
            if (manualShow == 'True') {
                plasmascriptline2 = "if (panel.height < 0) {panel.height = panel.height * -1;} ";
            }
            
            if (switchAction == 'True') {
                plasmascriptlinex = "if (panel.height < 0) {state1 = 'False';} if (panel2.height < 0) {state2 = 'False';} ";
                plasmascriptline2 = "panel.height = panel.height * -1; ";
                plasmascriptlinez = "panel2.height = panel2.height * -1; ";
                plasmascriptliney = "if (state2 != state1) {" + plasmascriptlinez + "} ";
            } else {
                plasmascriptlinex = "";
                plasmascriptliney = "";
                plasmascriptlinez = "";
            }
            
            //Attention need to leave panel vat set to the visible one \/
            //Not implemented feature grayed
            
        }
        
        if (plasmoid.configuration.forceDis == 'True') {
            plasmascriptline3 = "if (panel.location == 'left') {panel.location = 'right'; sleep(5); panel.location = 'left';} ";
            plasmascriptline4 = "if (panel.location == 'top') {panel.location = 'bottum'; sleep(5); panel.location = 'top';} ";
            plasmascriptline5 = "if (panel.location == 'right') {panel.location = 'left'; sleep(5); panel.location = 'right';} ";
            plasmascriptline6 = "if (panel.location == 'bottum') {panel.location = 'top'; sleep(5); panel.location = 'bottum'; }";
        } else {
            plasmascriptline3 = "";
            plasmascriptline4 = "";
            plasmascriptline5 = "";
            plasmascriptline6 = "";
        }
        
        //switchPanelMain <==> panelIdToIntStr
        //switchPanelSwitch <==> panelIdToIntStrSwitch
        
        plasmascriptline1 = "panel = panelById(panelIds[" + panelIdToIntStr + "]); panel2 = panelById(panelIds[" + panelIdToIntStrSwitch + "]); state1 = 'True'; state2 = 'True'; ";
        
        plasmascript = plasmascriptline1 + plasmascriptlinex + plasmascriptline2 + plasmascriptliney + plasmascriptline3 + plasmascriptline4 + plasmascriptline5 + plasmascriptline6;
	}
    
    function action_lockPanelCode() {
        executable.exec("qdbus org.kde.plasmashell /PlasmaShell org.kde.PlasmaShell.evaluateScript 'locked = true;'");
        executable.exec(advancedScript_p1 + '"' + advancedScript_p2 + '"');
	}
    
    Timer {
        id:timerLockPanel
        interval: 800
        onTriggered: action_lockPanelCode()
    }
    
    Timer {
        id:timerLockPanelLong
        interval: 12000
        onTriggered: action_lockPanelCode()
    }
    
    Timer {
        id:timerDelayToggle
        interval: 800
        onTriggered: executable.exec('qdbus org.kde.plasmashell /PlasmaShell evaluateScript ' + '"' + plasmascript + '"');
    }
    
	function action_unlockPanel() {
        executable.exec('qdbus org.kde.plasmashell /PlasmaShell evaluateScript ' + '"' + script + '"');
        
        if (plasmoid.configuration.advancedUnlock == 'True') {
            //If Plasma < v5.13 Then Use The Hacky Method
            if (plasmoid.immutability !== PlasmaCore.Types.Mutable) {
                executable.exec(unlockHacky1 + unlockHacky2);
            }
        } else {
            if (plasmoid.immutability !== PlasmaCore.Types.Mutable) {
                executable.exec("notify-send 'Toggle-Panel-Button :' 'Unable to unlock panel... \nPanel need to be unlocked...'");
            }
        }
	}
    
	function action_lockPanel() {
        if (plasmoid.configuration.advancedUnlock == 'True') {
            timerLockPanelLong.start();
        } else {
            timerLockPanel.start();
        }
        //executable.exec("qdbus org.kde.plasmashell /PlasmaShell org.kde.PlasmaShell.evaluateScript 'locked = true;'");
        //qdbus org.kde.plasmashell /PlasmaShell org.kde.PlasmaShell.evaluateScript "setImmutability('userImmutable');"
	}
        
	function action_showDesktopGrid() {
		executable.exec('qdbus org.kde.kglobalaccel /component/kwin invokeShortcut "ShowDesktopGrid"')
	}
    
	function action_HideUnhide() {
        action_prepareScript();
        
        if (plasmoid.configuration.newVersion == 'True') {
            executable.exec('qdbus org.kde.plasmashell /PlasmaShell evaluateScript ' + '"' + plasmascript + '"');
        } else {
            if (plasmoid.immutability !== PlasmaCore.Types.Mutable) {
                //not unlocked
                action_unlockPanel();
                if (plasmoid.configuration.advancedUnlock == 'True') {
                    timerDelayToggle.start();
                } else {
                    executable.exec('qdbus org.kde.plasmashell /PlasmaShell evaluateScript ' + '"' + plasmascript + '"');
                }
                action_lockPanel();
            } else {
                executable.exec('qdbus org.kde.plasmashell /PlasmaShell evaluateScript ' + '"' + plasmascript + '"');
            }
        }
        
	}
    
    Timer {
        id:timerToggle
        interval: 10000
        onTriggered: action_HideUnhide()
    }
    
	function activate() { 
		if (plasmoid.configuration.clickCommand == 'HideAutoUnhide') {
            action_HideUnhide();
            timerToggle.start();
		} 
        else if (plasmoid.configuration.clickCommand == 'HideUnhide') {
            action_HideUnhide()
		}
	}    
    
	function action_hideDesktopPanel() {
        manualHide = 'True';switchAction = 'False';
        action_HideUnhide();
        manualHide = 'False';switchAction = 'True';
	}  
    
	function action_showDesktopPanel() {
        manualShow = 'True';switchAction = 'False';
        action_HideUnhide();
        manualShow = 'False';switchAction = 'True';
	}  
    
	function action_hideDesktopPanel2() {
        switchPanelMain = plasmoid.configuration.clickCommandID2;
        manualHide = 'True';switchAction = 'False';
        action_HideUnhide();
        manualHide = 'False';switchAction = 'True';
        switchPanelMain = plasmoid.configuration.clickCommandID;
	}  
    
	function action_showDesktopPanel2() {
        switchPanelMain = plasmoid.configuration.clickCommandID2;
        manualShow = 'True';switchAction = 'False';
        action_HideUnhide();
        manualShow = 'False';switchAction = 'True';
        switchPanelMain = plasmoid.configuration.clickCommandID;
	}
    
    // Updater 2/3 ==================================================================================================================================
    Timer {
        id:timerStartUpdater
        interval: 300000
        onTriggered: updaterNotification(false)
    }
    
    PlasmaCore.DataSource {
        id: executableNotification
        engine: "executable"
        onNewData: disconnectSource(sourceName) // cmd finished
        function exec(cmd) {
            connectSource(cmd)
        }
    }
    
    function availableUpdate() {
        var notificationCommand = "notify-send --icon=remmina-panel 'Plasmoid KDE Switch Panel' 'An update is available \n<a href=\"https://www.opendesktop.org/p/1289173/\">Update link</a>' -t 30000";
        executableNotification.exec(notificationCommand);
    }

    function noAvailableUpdate() {
        var notificationCommand = "notify-send --icon=remmina-panel 'Plasmoid KDE Switch Panel' 'Your current version is up to date' -t 30000";
        executableNotification.exec(notificationCommand);
    }
    
    function updaterNotification(notifyUpdated) {
        var xhr = new XMLHttpRequest;
        xhr.responseType = 'text';
        xhr.open("GET", "https://raw.githubusercontent.com/Intika-Linux-Plasmoid/plasmoid-switch-panel/master/version");
        xhr.onreadystatechange = function() {
            if (xhr.readyState == XMLHttpRequest.DONE) {
                updateResponse = xhr.responseText;
                console.log('.'+updateResponse+'.');
                console.log('.'+currentVersion+'.');
                if (updateResponse.localeCompare(currentVersion) && updateResponse.localeCompare('') && updateResponse.localeCompare('404: Not Found\n')) {
                    availableUpdate();
                } else if (notifyUpdated) {
                    noAvailableUpdate();
                }
            }
        };
        xhr.send();
    }
    
    function action_checkUpdate() {
        updaterNotification(true);
    }
    // ==============================================================================================================================================

	Component.onCompleted: {
        //plasmoid.action('configure').trigger() // Uncomment to open the config window on load.
		plasmoid.setAction("showDesktopGrid", i18n("Show Desktop Grid"), "view-grid");
        plasmoid.setAction("showDesktopPanel", i18n("Show Panel One"), "bboxprev");
        plasmoid.setAction("showDesktopPanel2", i18n("Show Panel Two"), "bboxprev");
        plasmoid.setAction("hideDesktopPanel2", i18n("Hide Panel Two"), "bboxnext");
        plasmoid.setAction("hideDesktopPanel", i18n("Hide Panel One"), "bboxnext");
		
        // Updater 3/3 ==============================================================================================================================
        plasmoid.setAction("checkUpdate", i18n("Check for updates on github"), "view-grid");
        if (checkUpdateStartup) {timerStartUpdater.start();}
        // ==========================================================================================================================================
	}
}
