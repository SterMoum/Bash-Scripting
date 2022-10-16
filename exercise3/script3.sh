Help()
{
   # Display Help
   echo "The main goal of this scipt is to analyze books from the GUTENBERG PROJECT "
   echo "and present to the user the n words that appear more often in descending order." 
   echo "You can find books of this project for free here: https://www.gutenberg.org/."
   echo "Arguments:"
   echo "First Argument: A filename (which should be located locally in your disk) with the book's content"
   echo "Second Argument: A number n that declares how many words the user would like to be displayed"
}
if [[ $1 == "-h" || $1 == "--help" ]]; then
	Help
	exit
fi
#Get the line number of the substring: "*** START OF THIS PROJECT GUTENBERG EBOOK "
lineNum1=$(grep -n "*** START OF THIS PROJECT GUTENBERG EBOOK " $1 | head -n 1 | cut -d: -f1)
#Get the line number of the substring: "*** END OF THIS PROJECT GUTENBERG EBOOK "
lineNum2=$(grep -n "*** END OF THIS PROJECT GUTENBERG EBOOK " $1 | head -n 1 | cut -d: -f1)
#The file that should be edited must be between the lineNum1 and lineNum2 which contains the content's book
sed -i "$lineNum1, $lineNum2 ! d" $1
#Delete all special characters and keep the latin letters.Also, save the new content to a new temp file 
sed -e 's/[^a-zA-Z]/ /g;s/  */ /g' $1 > temp.txt
#Make all leters lowercase
sed -i 's/.*/\L&/g' temp.txt
#Edit the file in order to print the n words that appear more often in a descending order 
sed -e 's/[^[:alpha:]]/ /g' temp.txt | tr '\n' " " |  tr -s " " | tr " " '\n'| tr 'A-Z' 'a-z' | sort | uniq -c | sort -nr | nl | head -$2
