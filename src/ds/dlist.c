#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "dlist.h"

dlist_t *dlist_new()
{
	dlist_t *dlist;

	if (NULL == (dlist = (dlist_t*)malloc(sizeof(dlist_t)))) {
		perror("malloc failed");
		exit(1);
	}

	dlist->head = NULL;
	dlist->tail = NULL;
	dlist->length = 0;
	
	return dlist;
}

void dlist_destroy(dlist_t *dlist)
{
	node_t *node;

	if (!dlist) {
		return;
	}

	node = dlist->head;
	while (!node) {
		dlist->head = node->next;
		free(node->data);
		free(node);
		node = dlist->head;
	}

	free(dlist);
	dlist = NULL;
}

void dlist_append(dlist_t *dlist, void *data, int size)
{

	node_t *node;
	void *clone_data;

	if (!dlist || !data) {
		return;
	}
	
	if (!(node = (node_t*)malloc(sizeof(node_t)))) {
		perror("malloc failed");
		exit(1);
	} 

	if (!(clone_data = malloc(size))) {
		perror("malloc failed");
		exit(1);
	}

	memcpy(clone_data, data, size);

	node->data = clone_data;
	node->next = NULL;

	if (!dlist->head) {
		dlist->head = node;
		dlist->tail = node;
		node->prev = NULL;
	} else {
		node->prev = dlist->tail;
		dlist->tail->next = node;
		dlist->tail = node;
	}
	dlist->length++;
}

void dlist_foreach(dlist_t *dlist, void* (*visit)(void *ctx, node_t *node), void *ctx)
{
	node_t *iter;

	if (!dlist || !visit) {
		return ;
	}

	iter = dlist->head;
	while (iter) {
		visit(ctx, iter);
		iter = iter->next;
	}
}


//====================
node_t *dlist_find(dlist_t *dlist, void *data, int (*compare) (void *v1, void *v2))
{
	node_t *tmp;
	int rc; 

	if (!dlist || !data) {
		return NULL;
	}

	tmp = dlist->head->next;
	while (tmp) {
		rc = compare(tmp->data, data);
		if (!rc) {
			return tmp;
		} else {
			tmp = tmp->next;
		} 
	}

	return NULL;
}


void dlist_delete(dlist_t *dlist, void *data, int (*compare) (void *v1, void *v2))
{
	node_t *tmp;
	int rc;

	if (!dlist || !data) {
		return;
	}

	tmp = dlist->head->next;
	while (tmp) {
		rc = compare(tmp->data, data);
		if (!rc) {
			tmp->prev->next = tmp->next;
			tmp->next->prev = tmp->prev;
			free (tmp);
		} else {
			tmp = tmp->next;
		}
	}
}
//================================
bool dlist_empty(dlist_t *dlist)
{
	if (!dlist || !dlist->head) {
		return true;
	}
	return false;
}

int dlist_get_length(dlist_t *dlist)
{
	if (dlist_empty(dlist)) {
		return 0;
	}
	return dlist->length;
}
