#!/bin/bash

#read config.ini
source ./config.ini

#count function
function substr_count(){
     local STRING=""
     local SEARCH=""
     STRING=$1
     SEARCH=$2
     echo ${STRING} | sed "s/${SEARCH}/${SEARCH}\n/g" | grep -c "${SEARCH}"
     return $?
}

#the number of extension want to get 
countGetExtension=$((`substr_count ${getExtension} ','`+1))
#the number of extension dont want to get 
countNotGetExtension=$((`substr_count ${notGetExtension} ','`+1))
#the number of directory dont want to get extension
countNotGetDir=$((`substr_count ${notGetDir} ','`+1))

#1 find the extension want to get
for ((i=0;i<${countGetExtension};i++))
  do
    #when the extension want to get is not null
    if [ ${getExtension} != 'ALL' ]; then
      #when the number of extension want to get is 1
      if [ ${countGetExtension} = 1 ]; then
        extensionForGet=${getExtension}
      #when the number of extension want to get is >1
      else
        extensionForGet=`echo ${getExtension} | cut -d ',' -f $((${i}+1))`
      fi    
      for j in `find -O3 -L ${pathSource} -type f -name "*.${extensionForGet}"`
        do echo "${domain}${j#*${pathSource}/}" 
      done >> ${pathResult}/${tempFile}
    else
      for j in `find -O3 -L ${pathSource} -name "*" -type f`
        do echo "${domain}${j#*${pathSource}/}" 
      done >> ${pathResult}/${tempFile}
    fi
done

#2 delete the directory dont want to get the extension
for ((i=0;i<${countNotGetDir};i++))
  do
    #when the directory dont want to get the extension is not null
    if [ ${notGetDir} != 'NO' ]; then
      #when the number of directory dont want to get the extension is 1
      if [ ${countNotGetDir} = 1 ]; then
        dirNotForGet=${notGetDir}
      #when the number of directory dont want to get the extension is >1
      else
        dirNotForGet=`echo ${notGetDir} | cut -d ',' -f $((${i}+1))`
      fi
      sed -i -e '/'${dirNotForGet}'\//d' ${pathResult}/${tempFile}
    fi
done

#3 delete the extension dont want to get
for ((i=0;i<${countNotGetExtension};i++))
  do
    #when the extension dont want to get is not null
    if [ ${notGetExtension} != 'NO' ]; then
      #when the number of extension dont want to get is 1
      if [ ${countNotGetExtension} = 1 ]; then
        extensionNotForGet=${notGetExtension}
      #when the number of extension dont want to get is >1
      else
        extensionNotForGet=`echo ${notGetExtension} | cut -d ',' -f $((${i}+1))`
      fi
      sed -i -e '/.'${extensionNotForGet}'/d' ${pathResult}/${tempFile}
    fi
done

#4 templeFile --> resultFile
mv ${pathResult}/${tempFile} ${pathResult}/${resultFile}

