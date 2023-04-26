Set-PSReadlineKeyHandler -Key Tab -Function MenuComplete
Set-PSReadlineKeyHandler -Key UpArrow -Function HistorySearchBackward
Set-PSReadlineKeyHandler -Key DownArrow -Function HistorySearchForward
Set-PSReadLineOption -HistorySearchCursorMovesToEnd

function coco {
    cd C:\Users\ut06925\Documents\SEGU\1_CO
}

function word {

    param(
        [string]$filename
    )

    Start-Process "C:\Program Files\Microsoft Office\root\Office16\WINWORD.EXE" $filename
}

function .. {
    cd ..
}
