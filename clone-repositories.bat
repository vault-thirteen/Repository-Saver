@ECHO OFF

SET repos_folder=Repositories
SET repo_list=List.txt
SET git=git

:: Achtung! Undocumented feature!
SET zipper=7
SET zipper=%zipper%z
ECHO %zipper%

MKDIR %repos_folder%
COPY %repo_list% %repos_folder%

CD %repos_folder%
FOR /F "usebackq tokens=*" %%A IN ("%repo_list%") DO (
	ECHO %%A
	%git% clone %%A
)
CD ..

FOR /F "usebackq tokens=1,2 delims==" %%i IN (`wmic os get LocalDateTime /VALUE 2^>NUL`) DO IF '.%%i.'=='.LocalDateTime.' SET ldt=%%j
SET ldt=%ldt:~0,4%-%ldt:~4,2%-%ldt:~6,2%_%ldt:~8,2%-%ldt:~10,2%
SET time_text=%ldt%

SET archive_name=%repos_folder%_%time_text%.7z
ECHO Compressing "%repos_folder%" into "%archive_name%".
SET tmp_archive_name=tmp.7z

%zipper% a -mx=9 %tmp_archive_name% %repos_folder%
%zipper% t %tmp_archive_name%
RENAME %tmp_archive_name% %archive_name%

RMDIR /s /q %repos_folder%
