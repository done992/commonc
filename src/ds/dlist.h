#ifndef DLIST_H
#define DLIST_H

#include "src/util/constants.h"
#include "src/util/common.h"

BEGIN_C_DECLS

typedef struct node {
	struct node *prev;
	struct node *next;
	void *data;
} node_t;

typedef struct {
	node_t *head;
	node_t *tail;
	int length;
} dlist_t;


extern dlist_t *dlist_new();

extern void dlist_destroy(dlist_t *dlist);

extern void dlist_append(dlist_t *dlist, void *data, int size);

extern void dlist_foreach(dlist_t *dlist, void* (*visit)(void *ctx, node_t *node), void *ctx);

//


extern node_t *dlist_find(dlist_t *dlist, void *data, int (*compare) (void *v1, void *v2));

extern void dlist_delete(dlist_t *dlist, void *data, int (*compare) (void *v1, void *v2));

extern bool dlist_empty(dlist_t *dlist);

extern int dlist_get_length(dlist_t *dlist);

END_C_DECLS

#endif
