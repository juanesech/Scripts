#Variables
$cant = ${p:environment/cant}
$sname = "${p:environment/sname}"
$bin = "${p:environment/sbin}"
$binPath = "${p:environment/spath}"

#Kill Service Manager Console
echo "Closing Service Manager Console"
taskkill /F /IM mmc.exe

#Delete services
ForEach ($i In sc.exe query state= all | select-string -pattern "SERVICE_NAME: $sname*") {
    $service = ("$i").Substring(14)
    sc.exe stop $service
    echo "Deleting $service"
    sc.exe delete $service
    echo ""
}
sleep 10

#Uptade binaries
robocopy "Online\SgiWindowsServices\Notificaciones Asincronas SGI" "$binPath"

#Create services
for ($k=1; $k -le $cant; $k++){
    echo "Creating $sname$k Service"
    sc.exe create $sname$k binPath=$binPath\$bin start=auto DisplayName=$sname$k group=SGI
    sc.exe start $sname$k
    echo ""
}

exit $LastExitCode
