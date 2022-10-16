function foo()
{
    link="$1"
    #Get a token of the current website(md5sum provides a different token of each website)
    token=$(wget -qO- $link | md5sum)
    #if wget fails to download then print the message below
    if [[ "$?" != "0" ]]; then
        echo "$link FAILED"
        exit
    fi
    #Checking if websites is checked for the first time
    if grep -Fxq "$link" temp.txt;then 
    	#Checking if website has changed its content from the last time it entered the script 
        if grep -Fxq "$token" temp.txt; then
            :
        else
        	#If the website has changed from the last time print the message below and renew the token file
            echo "$link"
            echo "$token" >> temp.txt
        fi

    else
    	#If the website is checked for the first time print the messages below
        echo "$link" >> temp.txt
        echo "$token" >> temp.txt
        echo "$link INIT"
    fi 
}

prefix="#"

if [ ! -d "temp.txt" ];
then 
	touch temp.txt
fi

while IFS= read -r link;
do
	firstCharacter=${link:0:1}
	#Lines that start with '#' should be recognised as comments
	if [[ $firstCharacter != $prefix ]]; then
			foo $link 
	fi

done < websites.txt