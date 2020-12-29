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

        // vertex[tid].setValue(INT_MAX);
        // for (int i = in_start; i < in_end; i++) {
        //   vertex[tid].setInEdge(i - in_start, incol[i], INT_MAX);
        // }
    }
}
__global__ void part_kern1_initObject(VirtVertex<int, int> **vertex,
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

        vertex[tid]->setValueV(INT_MAX);
        for (int i = in_start; i < in_end; i++) {
            vertex[tid]->setInEdgeV(i - in_start, incol[i], INT_MAX);
        }
    }
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
            vertex[tid]->setOutEdgeV(vertex, tid, i - out_start, col[i],
                                    INT_MAX);
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
            vertex[tid]->setOutEdgeV(vertex, tid, i - out_start, col[i],
                                    INT_MAX);
        }
    }
}

__managed__ __align__(16) char buf2[128];
template <class myType>
__global__ void vptrPatch(myType *array, int n) {
    int tid = threadIdx.x + blockIdx.x * blockDim.x;
    // printf("-----\n");
    myType *obj;
    obj = new (buf2) myType();
    // void *p;
    // p=(void *)0x111111111;
    // memcpy(p, obj, sizeof(void *));
    // printf("---%p--\n", p);
    if (tid < n) {
        memcpy(&array[tid], obj, sizeof(void *));
        // printf("---%p--\n",p);
    }
}

__global__ void vptrPatch_Edge(ChiVertex<int, int> *vertex, int n) {
    int tid = threadIdx.x + blockIdx.x * blockDim.x;

    Edge<int> *obj;
    obj = new (buf2) Edge<int>();

    if (tid < n)
        if (tid == 0)
            vertex[tid].vptrPatch(obj, 1);
        else
            vertex[tid].vptrPatch(obj, 1);
}
__managed__ range_tree_node *range_tree;
__managed__ unsigned tree_size_g;
__managed__ void *temp_copyBack;
__managed__ void *temp_Bfs;

__global__ void BFS(VirtVertex<int, int> **vertex, GraphChiContext *context,
                    int iteration) {
  int tid = blockDim.x * blockIdx.x + threadIdx.x;
  if (tid < context->getNumVertices()) {
    if (iteration == 0) {
      if (tid == 0) {

        switch (vertex[tid]->type) {
        case 0:
          vertex[tid]->setValueC(0);
          break;
        case 1:
          vertex[tid]->setValueV(0);
          break;
        }
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
            outEdge->setValueC(1);
            break;
          case 1:
            outEdge->setValueV(1);
            break;
          }
        }
      }
    } else {
      int curmin;

      switch (vertex[tid]->type) {
      case 0:
        curmin = vertex[tid]->getValueC();
        break;
      case 1:
        curmin = vertex[tid]->getValueV();
        break;
      }
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
        ChiEdge<int> *inEdge;

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
          curmin = min(curmin, inEdge->getValueC());
          break;
        case 1:
          curmin = min(curmin, inEdge->getValueV());
          break;
        }
      }
      int vertValue;

      switch (vertex[tid]->type) {
      case 0:
        vertValue = vertex[tid]->getValueC();
        break;
      case 1:
        vertValue = vertex[tid]->getValueV();
        break;
      }
      if (curmin < vertValue) {

        switch (vertex[tid]->type) {
        case 0:
          vertex[tid]->setValueC(curmin);
          break;
        case 1:
          vertex[tid]->setValueV(curmin);
          break;
        }
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

          int edgeValue;

          switch (outEdge->type) {
          case 0:
            edgeValue = outEdge->getValueC();
            break;
          case 1:
            edgeValue = outEdge->getValueV();
            break;
          }
          if (edgeValue > curmin + 1) {
            switch (outEdge->type) {
            case 0:
              outEdge->setValueC(curmin + 1);
              break;
            case 1:
              outEdge->setValueV(curmin + 1);
              break;
            }
          }
        }
      }
    }
  }
}

__managed__ void *temp_vfun;
__global__ void vfunCheck(VirtVertex<int, int> *vertex) {
    void **vtable;
    unsigned tree_size = tree_size_g;
    int tid = blockDim.x * blockIdx.x + threadIdx.x;
    vtable = get_vfunc(&vertex[tid], range_tree, tree_size);
    temp_vfun = vtable[1];
    vertex[tid].setIdV(155);
    temp_vfun = vtable[0];
    printf("%d\n", vertex[tid].getIdV());

    temp_vfun = vtable[3];
    vertex[tid].setValueV(999);
    temp_vfun = vtable[2];
    printf("%d\n", vertex[tid].getValueV());
    temp_vfun = vtable[4];
    printf("%d\n", vertex[tid].numInEdgesV());
    temp_vfun = vtable[5];
    printf("%d\n", vertex[tid].numOutEdgesV());
    temp_vfun = vtable[6];
    printf("%p\n", vertex[tid].getInEdgeV(0));
    temp_vfun = vtable[7];
    printf("%p\n", vertex[tid].getOutEdgeV(0));
}

void BFS_cpu(VirtVertex<int, int> *vertex, GraphChiContext *context) {
    int tid = 0;
    // printf("ffff\n");
    for (tid = 0; tid < context->getNumVertices(); tid++) {
        if (context->getNumIterations() == 0) {
            if (tid == 0) {
                vertex[tid].setValueV(0);
                int numOutEdge;
                numOutEdge = vertex[tid].numOutEdgesV();
                for (int i = 0; i < numOutEdge; i++) {
                    ChiEdge<int> *outEdge;
                    outEdge = vertex[tid].getOutEdgeV(i);
                    outEdge->setValueV(1);
                }
            }
        } else {
            int curmin;
            curmin = vertex[tid].getValueV();
            int numInEdge;
            numInEdge = vertex[tid].numInEdgesV();
            for (int i = 0; i < numInEdge; i++) {
                ChiEdge<int> *inEdge;
                inEdge = vertex[tid].getInEdgeV(i);
                curmin = min(curmin, inEdge->getValueV());
            }
            int vertValue;
            vertValue = vertex[tid].getValueV();
            if (curmin < vertValue) {
                vertex[tid].setValueV(curmin);
                int numOutEdge;
                numOutEdge = vertex[tid].numOutEdgesV();
                for (int i = 0; i < numOutEdge; i++) {
                    ChiEdge<int> *outEdge;
                    outEdge = vertex[tid].getOutEdgeV(i);
                    int edgeValue;
                    edgeValue = outEdge->getValueV();
                    if (edgeValue > curmin + 1) {
                        outEdge->setValueV(curmin + 1);
                    }
                }
            }
        }
        //  context->setNumIterations(context->getNumIterations() + 1);
    }
}

__global__ void copyBack(VirtVertex<int, int> **vertex,
                         GraphChiContext *context, int *index) {
    int tid = blockDim.x * blockIdx.x + threadIdx.x;
    unsigned tree_size = tree_size_g;
    // ChiVertex<int, int> *obj;
    // obj = new (buf2) ChiVertex<int, int>();
    // long ***mVtable = (long ***)&vertex[tid];
    // long ***mVtable2 = (long ***)obj;
    // //memcpy(&vertex[tid],obj,sizeof(void*));
    // printf("[%d]-obj %p vert %p\n",tid,*mVtable2,*mVtable);
    // *mVtable=*mVtable2;
    // printf("[%d]after obj %p vert %p\n",tid,*mVtable2,*mVtable);
    if (tid < context->getNumVertices()) {
        void **vtable = get_vfunc(vertex[tid], range_tree, tree_size);
        temp_copyBack = vtable[2];
        // printf("%d\n",index[tid]);
        index[tid] = vertex[tid]->getValueV();
        //  if(mVtable[0][0]!=mVtable2[0][0])
        //  printf("[%d]why !! obj %p vert
        //  %p\n",tid,mVtable[0][0],mVtable2[0][0]);
        // printf("%d\n",index[tid]);
    }
}
