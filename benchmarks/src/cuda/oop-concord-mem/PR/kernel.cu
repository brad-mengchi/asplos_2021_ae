#include "parse_oo.h"

void initContext(GraphChiContext *context, int vertices, int edges) {
    context->setNumIterations(0);
    context->setNumVertices(vertices);
    context->setNumEdges(edges);
}
void part0_initObject(ChiVertex<float, float> **vertex,
                      GraphChiContext *context, int *row, int *col, int *inrow,
                      int *incol, obj_alloc *alloc) {
    int tid = 0;

    for (tid = 0; tid < context->getNumVertices(); tid++) {
        vertex[tid] =
            (ChiVertex<float, float> *)alloc->calloc<ChiVertex<float, float> >(
                1);
    }
}
void part1_initObject(ChiVertex<float, float> **vertex,
                      GraphChiContext *context, int *row, int *col, int *inrow,
                      int *incol, obj_alloc *alloc) {
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

__global__ void part_kern0_initObject(ChiVertex<float, float> **vertex,
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
        new (vertex[tid]) ChiVertex<float, float>(tid, indegree, outdegree);
    }
}
__global__ void part_kern1_initObject(ChiVertex<float, float> **vertex,
                                      GraphChiContext *context, int *row,
                                      int *col, int *inrow, int *incol) {
    int tid = blockDim.x * blockIdx.x + threadIdx.x;

    if (tid < context->getNumVertices()) {
        // int out_start = row[tid];
        // int out_end;
        // if (tid + 1 < context->getNumVertices()) {
        //   out_end = row[tid + 1];
        // } else {
        //   out_end = context->getNumEdges();
        // }

        int in_start = inrow[tid];
        int in_end;
        if (tid + 1 < context->getNumVertices()) {
            in_end = inrow[tid + 1];
        } else {
            in_end = context->getNumEdges();
        }

        for (int i = in_start; i < in_end; i++) {
            vertex[tid]->setInEdge(i - in_start, incol[i], 0.0f);
        }
    }
}
__global__ void kern_initOutEdge(ChiVertex<float, float> **vertex,
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
        // int in_start = inrow[tid];
        // int in_end;
        // if (tid + 1 < context->getNumVertices()) {
        //    in_end = inrow[tid + 1];
        //} else {
        //    in_end = context->getNumEdges();
        //}
        // int indegree = in_end - in_start;
        // int outdegree = out_end - out_start;
        // vertex[tid] = new ChiVertex<float, float>(tid, indegree, outdegree);
        // for (int i = in_start; i < in_end; i++) {
        //    vertex[tid]->setInEdge(i - in_start, incol[i], 0.0f);
        //}

        for (int i = out_start; i < out_end; i++) {
            vertex[tid]->setOutEdge(vertex, tid, i - out_start, col[i], 0.0f);
        }
    }
}
__global__ void initObject(ChiVertex<float, float> **vertex,
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
        vertex[tid] = new ChiVertex<float, float>(tid, indegree, outdegree);
        for (int i = in_start; i < in_end; i++) {
            vertex[tid]->setInEdge(i - in_start, incol[i], 0.0f);
        }
        // for (int i = out_start; i < out_end; i++) {
        //    vertex[tid]->setOutEdge(vertex, tid, i - out_start, col[i], 0.0f);
        //}
    }
}

__global__ void initOutEdge(ChiVertex<float, float> **vertex,
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
        // int in_start = inrow[tid];
        // int in_end;
        // if (tid + 1 < context->getNumVertices()) {
        //    in_end = inrow[tid + 1];
        //} else {
        //    in_end = context->getNumEdges();
        //}
        // int indegree = in_end - in_start;
        // int outdegree = out_end - out_start;
        // vertex[tid] = new ChiVertex<float, float>(tid, indegree, outdegree);
        // for (int i = in_start; i < in_end; i++) {
        //    vertex[tid]->setInEdge(i - in_start, incol[i], 0.0f);
        //}
        for (int i = out_start; i < out_end; i++) {
            vertex[tid]->setOutEdge(vertex, tid, i - out_start, col[i], 0.0f);
        }
    }
}
__managed__ range_tree_node *range_tree;
__managed__ unsigned tree_size_g;
__managed__ void *temp_copyBack;
__managed__ void *temp_PR;

__global__ void PageRank(ChiVertex<float, float> **vertex,
                         GraphChiContext *context, int iteration) {
	int tid = blockDim.x * blockIdx.x + threadIdx.x;
	if (tid < context->getNumVertices()) {
	  if (iteration == 0) {
		vertex[tid]->setValue(1.0f);
	  } else {
		float sum = 0.0f;
		int numInEdge;
		numInEdge = vertex[tid]->numInEdges();
		for (int i = 0; i < numInEdge; i++) {
		  ChiEdge<float> *inEdge;
		  inEdge = vertex[tid]->getInEdge(i);
		  switch (inEdge->type) {
			case 0:
			sum += inEdge->getValueChiEdge();
			  break;
			case 1:
			sum += inEdge->getValueEdge();
			  break;
			}
		 
		}
		vertex[tid]->setValue(0.15f + 0.85f * sum);
  
		/* Write my value (divided by my out-degree) to my out-edges so neighbors
		 * can read it. */
		int numOutEdge;
		numOutEdge = vertex[tid]->numOutEdges();
		float outValue = vertex[tid]->getValue() / numOutEdge;
		for (int i = 0; i < numOutEdge; i++) {
		  ChiEdge<float> *outEdge;
		  outEdge = vertex[tid]->getOutEdge(i);
		  switch (outEdge->type) {
			case 0:
			outEdge->setValueChiEdge(outValue);
			  break;
			case 1:
			outEdge->setValueEdge(outValue);
			  break;
			}
		 
		}
	  }
	  
	}
}

__global__ void copyBack(ChiVertex<float, float> **vertex,
                         GraphChiContext *context, float *pagerank) {
    int tid = blockDim.x * blockIdx.x + threadIdx.x;
    if (tid < context->getNumVertices()) {
        pagerank[tid] = vertex[tid]->getValue();
    }
}
