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

        vertex[tid].setValueV(INT_MAX);
        for (int i = in_start; i < in_end; i++) {
            vertex[tid].setInEdgeV(i - in_start, incol[i], INT_MAX);
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
            vertex[tid]->setInEdgeV(i - in_start, incol[i], 0);
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
            vertex[tid]->setOutEdgeV(vertex, tid, i - out_start, col[i], 0);
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

        vertex[tid].setValueV(INT_MAX);
        for (int i = in_start; i < in_end; i++) {
            vertex[tid].setInEdgeV(i - in_start, incol[i], INT_MAX);
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
            vertex[tid]->setOutEdgeV(vertex, tid, i - out_start, col[i], 0);
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

    switch (vertex[tid]->type) {
    case 0:
      numEdges = vertex[tid]->numEdgesC();
      break;
    case 1:
      numEdges = vertex[tid]->numEdgesV();
      break;
    }
    if (iteration == 0) {
      int vid;

      switch (vertex[tid]->type) {
      case 0:
        vid = vertex[tid]->getIdC();
        break;
      case 1:
        vid = vertex[tid]->getIdV();
        break;
      }

      switch (vertex[tid]->type) {
      case 0:
        vertex[tid]->setValueC(vid);
        break;
      case 1:
        vertex[tid]->setValueV(vid);
        break;
      }
    }
    int curMin;

    switch (vertex[tid]->type) {
    case 0:
      curMin = vertex[tid]->getValueC();
      break;
    case 1:
      curMin = vertex[tid]->getValueV();
      break;
    }
    for (int i = 0; i < numEdges; i++) {
      ChiEdge<int> *edge;

      switch (vertex[tid]->type) {
      case 0:
        edge = vertex[tid]->edgeC(i);
        break;
      case 1:
        edge = vertex[tid]->edgeV(i);
        break;
      }
      int nbLabel;

      switch (edge->type) {
      case 0:
        nbLabel = edge->getValueC();
        break;
      case 1:
        nbLabel = edge->getValueV();
        break;
      }
      if (iteration == 0) {
        switch (edge->type) {
        case 0:
          nbLabel = edge->getVertexIdC(); // Note!
          break;
        case 1:
          nbLabel = edge->getVertexIdV(); // Note!
          break;
        }
      }
      if (nbLabel < curMin) {
        curMin = nbLabel;
      }
    }

    /**
     * Set my new label
     */

    switch (vertex[tid]->type) {
    case 0:
      vertex[tid]->setValueC(curMin);
      break;
    case 1:
      vertex[tid]->setValueV(curMin);
      break;
    }
    int label = curMin;

    /**
     * Broadcast my value to neighbors by writing the value to my edges.
     */
    if (iteration > 0) {
      for (int i = 0; i < numEdges; i++) {
        ChiEdge<int> *edge;

        switch (vertex[tid]->type) {
        case 0:
          edge = vertex[tid]->edgeC(i);
          break;
        case 1:
          edge = vertex[tid]->edgeV(i);
          break;
        }
        int edgeValue;

        switch (edge->type) {
        case 0:
          edgeValue = edge->getValueC();
          break;
        case 1:
          edgeValue = edge->getValueV();
          break;
        }
        if (edgeValue > label) {
          switch (edge->type) {
          case 0:
            edge->setValueC(label);
            break;
          case 1:
            edge->setValueV(label);
            break;
          }
        }
      }
    } else {
      // Special case for first iteration to avoid overwriting
      int numOutEdge;

      switch (vertex[tid]->type) {
      case 0:
        numOutEdge = vertex[tid]->numOutEdgesC();
        break;
      case 1:
        numOutEdge = vertex[tid]->numOutEdgesV();
        break;
      }
      for (int i = 0; i < numOutEdge; i++) {
        ChiEdge<int> *outEdge;

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
          outEdge->setValueC(label);
          break;
        case 1:
          outEdge->setValueV(label);
          break;
        }
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
        cc[tid] = vertex[tid]->getValueV();
    }
}
