#include <stdio.h>
#include <stdlib.h>
#include <sys/types.h>
#include <dirent.h>

int main(int argc, char *argv[])
{
	DIR *dir;
	struct dirent *ent;

	if (argc != 2) {
		perror("Usage: program dirname");
		exit(1);
	}

	if (NULL == (dir = opendir(argv[1]))) {
		perror("can not open the dir");
		exit(1); 
	}

	while (NULL != (ent = readdir(dir))) {
		printf("%s\n", ent->d_name);
	}

	closedir(dir);
	return 0;
}
