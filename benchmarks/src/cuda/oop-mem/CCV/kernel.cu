/*
__global__ void initContext(GraphChiContext* context, int vertices, int edges) {

        context->setNumIterations(0);
        context->setNumVertices(vertices);
        context->setNumEdges(edges);

}

__global__ void initObject(VirtVertex<int, int> **vertex, GraphChiContext*
context,
        int* row, int* col, int* inrow, int* incol) {
    int tid = blockDim.x * blockIdx.x + threadIdx.x;
    if (tid < context->getNumVertices()) {
        int out_start = row[tid];
        int out_end;
        if (tid + 1 < context->getNumVertices()) {
            out_end = row[tid + 1];
        } else {
            out_end = context->getNumEdges();
        }
        int in_start = inrow[tid];
        int in_end;
        if (tid + 1 < context->getNumVertices()) {
            in_end = inrow[tid + 1];
        } else {
            in_end = context->getNumEdges();
        }
        int indegree = in_end - in_start;
        int outdegree = out_end - out_start;
        vertex[tid] = new ChiVertex<int, int>(tid, indegree, outdegree);
        for (int i = in_start; i < in_end; i++) {
            vertex[tid]->setInEdge(i - in_start, incol[i], 0);
        }
        //for (int i = out_start; i < out_end; i++) {
        //    vertex[tid]->setOutEdge(vertex, tid, i - out_start, col[i], 0.0f);
        //}
    }
}

__global__ void initOutEdge(VirtVertex<int, int> **vertex, GraphChiContext*
context,
        int* row, int* col) {
    int tid = blockDim.x * blockIdx.x + threadIdx.x;
    if (tid < context->getNumVertices()) {
        int out_start = row[tid];
        int out_end;
        if (tid + 1 < context->getNumVertices()) {
            out_end = row[tid + 1];
        } else {
            out_end = context->getNumEdges();
        }
        for (int i = out_start; i < out_end; i++) {
            vertex[tid]->setOutEdge(vertex, tid, i - out_start, col[i], 0);
        }
    }
}
*/
#include "parse_oo.h"

void initContext(GraphChiContext *context, int vertices, int edges) {
    // int tid = blockDim.x * blockIdx.x + threadIdx.x;

    context->setNumIterations(0);
    context->setNumVertices(vertices);
    context->setNumEdges(edges);
}

void initObject(VirtVertex<int, int> *vertex, GraphChiContext *context,
                int *row, int *col, int *inrow, int *incol, obj_alloc *alloc) {
    int tid = 0;

    for (tid = 0; tid < context->getNumVertices(); tid++) {
        int out_start = row[tid];
        int out_end;
        if (tid + 1 < context->getNumVertices()) {
            out_end = row[tid + 1];
        } else {
            out_end = context->getNumEdges();
        }
        int in_start = inrow[tid];
        int in_end;
        if (tid + 1 < context->getNumVertices()) {
            in_end = inrow[tid + 1];
        } else {
            in_end = context->getNumEdges();
        }
        int indegree = in_end - in_start;
        int outdegree = out_end - out_start;
        // vertex[tid].inEdgeDataArray =
        //     (ChiEdge<int> *)alloc->my_new<Edge<int>>(indegree);
        // vertex[tid].outEdgeDataArray =
        //     (ChiEdge<int> **)alloc->my_new<Edge<int> *>(outdegree);
        new (&vertex[tid]) ChiVertex<int, int>(tid, indegree, outdegree, alloc);

        vertex[tid].setValue(INT_MAX);
        for (int i = in_start; i < in_end; i++) {
            vertex[tid].setInEdge(i - in_start, incol[i], INT_MAX);
        }
        // for (int i = out_start; i < out_end; i++) {
        //    vertex[tid]->setOutEdge(vertex, tid, i - out_start, col[i], 0.0f);
        //}
    }
}

void part0_initObject(VirtVertex<int, int> **vertex, GraphChiContext *context,
                      int *row, int *col, int *inrow, int *incol,
                      obj_alloc *alloc) {
    int tid = 0;

    for (tid = 0; tid < context->getNumVertices(); tid++) {
        vertex[tid] =
            (VirtVertex<int, int> *)alloc->my_new<ChiVertex<int, int>>();
    }
}
void part1_initObject(VirtVertex<int, int> **vertex, GraphChiContext *context,
                      int *row, int *col, int *inrow, int *incol,
                      obj_alloc *alloc) {
    int tid = 0;

    for (tid = 0; tid < context->getNumVertices(); tid++) {
        // int out_start = row[tid];
        // int out_end;
        // if (tid + 1 < context->getNumVertices()) {
        //   out_end = row[tid + 1];
        // } else {
        //   out_end = context->getNumEdges();
        // }
        // int in_start = inrow[tid];
        // int in_end;
        // if (tid + 1 < context->getNumVertices()) {
        //   in_end = inrow[tid + 1];
        // } else {
        //   in_end = context->getNumEdges();
        // }
        // int indegree = in_end - in_start;
        // int outdegree = out_end - out_start;
        // vertex[tid].inEdgeDataArray =
        //     (ChiEdge<myType> *)alloc->my_new<Edge<myType>>(indegree);
        // vertex[tid].outEdgeDataArray =
        //     (ChiEdge<myType> **)alloc->my_new<Edge<myType> *>(outdegree);
        // new (&vertex[tid]) ChiVertex<int, int>(tid, indegree,
        // outdegree,alloc);
        vertex[tid]->set_in_out(alloc);
        // vertex[tid].setValue(INT_MAX);
        // for (int i = in_start; i < in_end; i++) {
        //   vertex[tid].setInEdge(i - in_start, incol[i], INT_MAX);
        // }
        // for (int i = out_start; i < out_end; i++) {
        //    vertex[tid]->setOutEdge(vertex, tid, i - out_start, col[i], 0.0f);
        //}
    }
}
__global__ void part_kern0_initObject(VirtVertex<int, int> **vertex,
                                      GraphChiContext *context, int *row,
                                      int *col, int *inrow, int *incol) {
    int tid = blockDim.x * blockIdx.x + threadIdx.x;

    if (tid < context->getNumVertices()) {
        int out_start = row[tid];
        int out_end;
        if (tid + 1 < context->getNumVertices()) {
            out_end = row[tid + 1];
        } else {
            out_end = context->getNumEdges();
        }
        int in_start = inrow[tid];
        int in_end;
        if (tid + 1 < context->getNumVertices()) {
            in_end = inrow[tid + 1];
        } else {
            in_end = context->getNumEdges();
        }
        int indegree = in_end - in_start;
        int outdegree = out_end - out_start;
        new (vertex[tid]) ChiVertex<int, int>(tid, indegree, outdegree);

        // for (int i = out_start; i < out_end; i++) {
        //    vertex[tid]->setOutEdge(vertex, tid, i - out_start, col[i], 0.0f);
        //}
    }

    // vertex[tid].setValue(INT_MAX);
    // for (int i = in_start; i < in_end; i++) {
    //   vertex[tid].setInEdge(i - in_start, incol[i], INT_MAX);
    // }
}
__global__ void part_kern1_initObject(VirtVertex<int, int> **vertex,
                                      GraphChiContext *context, int *row,
                                      int *col, int *inrow, int *incol) {
    int tid = blockDim.x * blockIdx.x + threadIdx.x;

    if (tid < context->getNumVertices()) {
        int out_end;
        if (tid + 1 < context->getNumVertices()) {
            out_end = row[tid + 1];
        } else {
            out_end = context->getNumEdges();
        }
        int in_start = inrow[tid];
        int in_end;
        if (tid + 1 < context->getNumVertices()) {
            in_end = inrow[tid + 1];
        } else {
            in_end = context->getNumEdges();
        }

        for (int i = in_start; i < in_end; i++) {
            vertex[tid]->setInEdge(i - in_start, incol[i], 0);
        }
    }
    // for (int i = out_start; i < out_end; i++) {
    //    vertex[tid]->setOutEdge(vertex, tid, i - out_start, col[i], 0.0f);
    //}
}
void initOutEdge(VirtVertex<int, int> **vertex, GraphChiContext *context,
                 int *row, int *col) {
    int tid = 0;

    for (tid = 0; tid < context->getNumVertices(); tid++) {
        int out_start = row[tid];
        int out_end;
        if (tid + 1 < context->getNumVertices()) {
            out_end = row[tid + 1];
        } else {
            out_end = context->getNumEdges();
        }

        for (int i = out_start; i < out_end; i++) {
            vertex[tid]->setOutEdge(vertex, tid, i - out_start, col[i], 0);
        }
    }
}

__global__ void kern_initObject(VirtVertex<int, int> *vertex,
                                GraphChiContext *context, int *row, int *col,
                                int *inrow, int *incol) {
    int tid = blockDim.x * blockIdx.x + threadIdx.x;

    if (tid < context->getNumVertices()) {
        int out_start = row[tid];
        int out_end;
        if (tid + 1 < context->getNumVertices()) {
            out_end = row[tid + 1];
        } else {
            out_end = context->getNumEdges();
        }

        int in_start = inrow[tid];
        int in_end;
        if (tid + 1 < context->getNumVertices()) {
            in_end = inrow[tid + 1];
        } else {
            in_end = context->getNumEdges();
        }
        int indegree = in_end - in_start;
        int outdegree = out_end - out_start;
        new (&vertex[tid]) ChiVertex<int, int>(tid, indegree, outdegree);

        vertex[tid].setValue(INT_MAX);
        for (int i = in_start; i < in_end; i++) {
            vertex[tid].setInEdge(i - in_start, incol[i], INT_MAX);
        }

        // for (int i = out_start; i < out_end; i++) {
        //    vertex[tid]->setOutEdge(vertex, tid, i - out_start, col[i], 0.0f);
    }
    //}
}
__global__ void kern_initOutEdge(VirtVertex<int, int> **vertex,
                                 GraphChiContext *context, int *row, int *col) {
    int tid = blockDim.x * blockIdx.x + threadIdx.x;
    if (tid < context->getNumVertices()) {
        int out_start = row[tid];
        int out_end;
        if (tid + 1 < context->getNumVertices()) {
            out_end = row[tid + 1];
        } else {
            out_end = context->getNumEdges();
        }
        for (int i = out_start; i < out_end; i++) {
            vertex[tid]->setOutEdge(vertex, tid, i - out_start, col[i], 0);
        }
    }
}

__managed__ range_tree_node *range_tree;
__managed__ unsigned tree_size_g;
__managed__ void *temp_copyBack;
__managed__ void *temp_CC;

__global__ void ConnectedComponent(VirtVertex<int, int> **vertex,
                                   GraphChiContext *context, int iteration) {
    int tid = blockDim.x * blockIdx.x + threadIdx.x;
    if (tid < context->getNumVertices()) {
        int numEdges;
        numEdges = vertex[tid]->numEdges();
        if (iteration == 0) {
            int vid = vertex[tid]->getId();
            vertex[tid]->setValue(vid);
        }
        int curMin;
        curMin = vertex[tid]->getValue();
        for (int i = 0; i < numEdges; i++) {
            ChiEdge<int> *edge;
            edge = vertex[tid]->edge(i);
            int nbLabel;
            nbLabel = edge->getValue();
            if (iteration == 0) {
                nbLabel = edge->getVertexId();  // Note!
            }
            if (nbLabel < curMin) {
                curMin = nbLabel;
            }
        }

        /**
         * Set my new label
         */
        vertex[tid]->setValue(curMin);
        int label = curMin;

        /**
         * Broadcast my value to neighbors by writing the value to my edges.
         */
        if (iteration > 0) {
            for (int i = 0; i < numEdges; i++) {
                ChiEdge<int> *edge;
                edge = vertex[tid]->edge(i);
                int edgeValue;
                edgeValue = edge->getValue();
                if (edgeValue > label) {
                    edge->setValue(label);
                }
            }
        } else {
            // Special case for first iteration to avoid overwriting
            int numOutEdge;
            numOutEdge = vertex[tid]->numOutEdges();
            for (int i = 0; i < numOutEdge; i++) {
                ChiEdge<int> *outEdge;
                outEdge = vertex[tid]->getOutEdge(i);
                outEdge->setValue(label);
            }
        }
    }
}

__global__ void copyBack(VirtVertex<int, int> **vertex,
                         GraphChiContext *context, int *cc) {
    int tid = blockDim.x * blockIdx.x + threadIdx.x;
    unsigned tree_size = tree_size_g;
    void **vtable;
    range_tree_node *table = range_tree;
    if (tid < context->getNumVertices()) {
        vtable = get_vfunc(vertex[tid], table, tree_size);
        temp_copyBack = vtable[1];
        cc[tid] = vertex[tid]->getValue();
    }
}
