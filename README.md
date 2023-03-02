# UNIX-RecycleBin-Scripts
UNIX has no recycle bin at the command line. When you remove a file or directory, it's gone and can't be restored. This project provides users with recycle bin which can be used to safely recycle and restore files. 
<hr>
<h2>Recycle Script</h2>
<p>
Recycle Script mimics the rm command which accepts the name of a file as a command line argument as rm does, but instead of deleting
the file, script moves it to a recyclebin directory called recyclebin located in your home directory.
</p>
<hr>
<ol>
<li> The file to be deleted will be a command line argument and the script will be executed as follows: 
`./recycle.sh {filename}` </li> <br>
         
<li> The filenames in the recyclebin, will be in the following format: `{filename}_{inode}`
For example, if a file named sampleFile with inode 1234 is recycled, the file in the recyclebin will be named sampleFile_1234. 
This gets around the potential problem of deleting two files
with the same name. The recyclebin will only contain files, not directories. </li><br>
         
<li> Script will create a hidden file called <i>".restore.info"</i> in $HOME. Each line of ths file will contain the name of the file in the recyclebin,
followed by a colon, followed by the original absolute path of the file. 
For example, if a file called sampleFile, with an inode of
1234 was recycled from the /home/project directory, .restore.info will contain:
sampleFile_1234:/home/project/sampleFile </li><br>
</ol>

<p><strong>Note:</strong><i>".restore.info"</i> will be hidden. To check its contents, press CTRL + H.<p>

<h2>Restore Script</h2>
<p>
Restore Script will restore individual files back to their original location. The user will determine which file is to be restored and use the file name with inode number
in order to restore the file by using the command: `./restore.sh {filename}_{inode}`. The file will be restored to its original location, using the pathname stored in the <i>".restore.info"</i> file. After the file has been successfully restored, the entry in the <i>".restore.info"</i> will be deleted.
<br>For example: ./restore.sh sampleFile_1234 <br>
</p>
