#include "parse_oo.h"

void initContext(GraphChiContext *context, int vertices, int edges) {
    context->setNumIterations(0);
    context->setNumVertices(vertices);
    context->setNumEdges(edges);
}
void part0_initObject(VirtVertex<float, float> **vertex,
                      GraphChiContext *context, int *row, int *col, int *inrow,
                      int *incol, obj_alloc *alloc) {
    int tid = 0;

    for (tid = 0; tid < context->getNumVertices(); tid++) {
        vertex[tid] = (VirtVertex<float, float> *)
                          alloc->my_new<ChiVertex<float, float>>();
    }
}
void part1_initObject(VirtVertex<float, float> **vertex,
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

__global__ void part_kern0_initObject(VirtVertex<float, float> **vertex,
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
__global__ void part_kern1_initObject(VirtVertex<float, float> **vertex,
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
            vertex[tid]->setInEdgeV(i - in_start, incol[i], 0.0f);
        }
    }
}
__global__ void kern_initOutEdge(VirtVertex<float, float> **vertex,
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
            vertex[tid]->setOutEdgeV(vertex, tid, i - out_start, col[i], 0.0f);
        }
    }
}
__global__ void initObject(VirtVertex<float, float> **vertex,
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
            vertex[tid]->setInEdgeV(i - in_start, incol[i], 0.0f);
        }
        // for (int i = out_start; i < out_end; i++) {
        //    vertex[tid]->setOutEdge(vertex, tid, i - out_start, col[i], 0.0f);
        //}
    }
}

__global__ void initOutEdge(VirtVertex<float, float> **vertex,
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
            vertex[tid]->setOutEdgeV(vertex, tid, i - out_start, col[i], 0.0f);
        }
    }
}
__managed__ range_tree_node *range_tree;
__managed__ unsigned tree_size_g;
__managed__ void *temp_copyBack;
__managed__ void *temp_PR;

__global__ void PageRank(VirtVertex<float, float> **vertex,
                         GraphChiContext *context, int iteration) {
  int tid = blockDim.x * blockIdx.x + threadIdx.x;
  if (tid < context->getNumVertices()) {
    if (iteration == 0) {

      switch (vertex[tid]->type) {
      case 0:
        vertex[tid]->setValueC(1.0f);
        break;
      case 1:
        vertex[tid]->setValueV(1.0f);
        break;
      }
    } else {
      float sum = 0.0f;
      int numInEdge;
	  
	  switch (vertex[tid]->type) {
		case 0:
		numInEdge = vertex[tid]->numInEdgesC();
		  break;
		case 1:
		numInEdge = vertex[tid]->numInEdgesV();
		  break;
		}
      for (int i = 0; i < numInEdge; i++) {
        ChiEdge<float> *inEdge;
		
		switch (vertex[tid]->type) {
			case 0:
			inEdge = vertex[tid]->getInEdgeC(i);
			  break;
			case 1:
			inEdge = vertex[tid]->getInEdgeV(i);
			  break;
			}
		
		
        switch (inEdge->type) {
			case 0:
			sum += inEdge->getValueC();
			  break;
			case 1:
			sum += inEdge->getValueV();
			  break;
			}
      }
      
	  switch (vertex[tid]->type) {
		case 0:
		vertex[tid]->setValueC(0.15f + 0.85f * sum);
		  break;
		case 1:
		vertex[tid]->setValueV(0.15f + 0.85f * sum);
		  break;
		}
      /* Write my value (divided by my out-degree) to my out-edges so neighbors
       * can read it. */
      int numOutEdge;
	 
	  switch (vertex[tid]->type) {
		case 0:
		numOutEdge = vertex[tid]->numOutEdgesC();
		  break;
		case 1:
		numOutEdge = vertex[tid]->numOutEdgesV();
				  break;
		}
	  float outValue;
	  
	  switch (vertex[tid]->type) {
		case 0:
		outValue= vertex[tid]->getValueC() / numOutEdge;
		  break;
		case 1:
		outValue= vertex[tid]->getValueV() / numOutEdge;
				  break;
		}
      for (int i = 0; i < numOutEdge; i++) {
        ChiEdge<float> *outEdge;
		
		switch (vertex[tid]->type) {
			case 0:
			outEdge = vertex[tid]->getOutEdgeC(i);
			  break;
			case 1:
			outEdge = vertex[tid]->getOutEdgeV(i);
					  break;
			}
		
		switch (outEdge->type) {
			case 0:
			outEdge->setValueC(outValue);
			  break;
			case 1:
			outEdge->setValueV(outValue);
			  break;
			}
      }
    }
  }
}

__global__ void copyBack(VirtVertex<float, float> **vertex,
                         GraphChiContext *context, float *pagerank) {
    int tid = blockDim.x * blockIdx.x + threadIdx.x;
    if (tid < context->getNumVertices()) {
        pagerank[tid] = vertex[tid]->getValueV();
    }
}
