#include <assert.h>
#include <chrono>
#include <curand_kernel.h>
#include <limits>
#include <stdio.h>
#define ALL __noinline__ __host__ __device__
#define CONCORD2(ptr, fun)        \
    if (ptr->classType == 0)      \
        ptr->Base##fun;           \
    else if (ptr->classType == 1) \
        ptr->fun;
#define CONCORD3(r, ptr, fun)     \
    if (ptr->classType == 0)      \
        r = ptr->Base##fun;       \
    else if (ptr->classType == 1) \
        r = ptr->fun;

#define GET_MACRO(_1, _2, _3, _4, NAME, ...) NAME
#define CONCORD(...) \
    GET_MACRO(__VA_ARGS__, CONCORD4, CONCORD3, CONCORD2, CONCORD1)(__VA_ARGS__)

#include "../configuration.h"
#include "../dataset.h"
#include "../../../mem_alloc/mem_alloc.h"
class SpringBase;
class NodeBase {
public:
  SpringBase *springs[kMaxDegree];
  int num_springs;
  int distance;
  float pos_x;
  float pos_y;
  float vel_x;
  float vel_y;
  float mass;
  char type;
  int classType = 0;
  __device__ __host__ virtual void dummy() = 0;
    ALL NodeBase() { classType = 0; }
    ALL SpringBase *Basespring(unsigned i) { return this->springs[i]; }
    ALL void Basepull() {
        this->pos_x += this->vel_x * kDt;
        this->pos_y += this->vel_y * kDt;
    }
    ALL float Basedistance_to(NodeBase *other) {
        float dx = this->pos_x - other->pos_x;
        float dy = this->pos_y - other->pos_y;
        float dist_sq = dx * dx + dy * dy;
        return sqrt(dist_sq);
    }
    __device__ __noinline__ void Baseremove_spring(SpringBase *spring) {
        for (int i = 0; i < kMaxDegree; ++i) {
            if (this->springs[i] == spring) {
                this->springs[i] = NULL;
                if (atomicSub(&this->num_springs, 1) == 1) {
                    // Deleted last spring.
                    this->type = 0;
                }
                return;
            }
        }

        // Spring not found.
        assert(false);
    }
    ALL float Baseunit_x(NodeBase *other, float dist) {
        float dx = this->pos_x - other->pos_x;
        float unit_x = dx / dist;
        return unit_x;
    }
    ALL float Baseunit_y(NodeBase *other, float dist) {
        float dy = this->pos_y - other->pos_y;
        float unit_y = dy / dist;
        return unit_y;
    }
    ALL void Baseupdate_vel_x(float force_x) {
        this->vel_x += force_x * kDt / this->mass;
        this->vel_x *= 1.0f - kVelocityDampening;
    }
    ALL void Baseupdate_vel_y(float force_y) {
        this->vel_y += force_y * kDt / this->mass;
        this->vel_y *= 1.0f - kVelocityDampening;
    }
    ALL void Baseupdate_pos_x(float force_x) { this->pos_x += this->vel_x * kDt; }
    ALL void Baseupdate_pos_y(float force_x) { this->pos_y += this->vel_y * kDt; }
    ALL void Baseset_distance(float dist) { this->distance = dist; }
    ALL float Baseget_distance() { return this->distance; }

    //////

    ALL SpringBase *spring(unsigned i) { return this->springs[i]; }
    ALL void pull() {
        this->pos_x += this->vel_x * kDt;
        this->pos_y += this->vel_y * kDt;
    }
    ALL float distance_to(NodeBase *other) {
        float dx = this->pos_x - other->pos_x;
        float dy = this->pos_y - other->pos_y;
        float dist_sq = dx * dx + dy * dy;
        return sqrt(dist_sq);
    }
    __device__ __noinline__ void remove_spring(SpringBase *spring) {
        for (int i = 0; i < kMaxDegree; ++i) {
            if (this->springs[i] == spring) {
                this->springs[i] = NULL;
                if (atomicSub(&this->num_springs, 1) == 1) {
                    // Deleted last spring.
                    this->type = 0;
                }
                return;
            }
        }

        // Spring not found.
        assert(false);
    }
    ALL float unit_x(NodeBase *other, float dist) {
        float dx = this->pos_x - other->pos_x;
        float unit_x = dx / dist;
        return unit_x;
    }
    ALL float unit_y(NodeBase *other, float dist) {
        float dy = this->pos_y - other->pos_y;
        float unit_y = dy / dist;
        return unit_y;
    }
    ALL void update_vel_x(float force_x) {
        this->vel_x += force_x * kDt / this->mass;
        this->vel_x *= 1.0f - kVelocityDampening;
    }
    ALL void update_vel_y(float force_y) {
        this->vel_y += force_y * kDt / this->mass;
        this->vel_y *= 1.0f - kVelocityDampening;
    }
    ALL void update_pos_x(float force_x) { this->pos_x += this->vel_x * kDt; }
    ALL void update_pos_y(float force_x) { this->pos_y += this->vel_y * kDt; }
    ALL void set_distance(float dist) { this->distance = dist; }
    ALL float get_distance() { return this->distance; }
};

class Node : public NodeBase {
public:
  __device__ __host__ void dummy() {}
  ALL Node() { classType = 1; }
};

class SpringBase {
public:
  float factor;
  float initial_length;
  float force;
  float max_force;
  bool is_active;

  NodeBase *p1;
  NodeBase *p2;
  bool delete_flag;
  int classType = 0;
  __device__ __host__ virtual void dummy() = 0;
    ALL SpringBase(){classType = 0;}
    ALL void Basedeactivate() { this->is_active = false; }
    ALL void Baseupdate_force(float displacement) {
        this->force = this->factor * displacement;
    }
    ALL float Baseget_force() { return this->force; }
    ALL float Baseget_init_len() { return this->initial_length; }
    ALL bool Baseget_is_active() { return this->is_active; }
    ALL void Baseset_is_active(bool active) { this->is_active = active; }
    ALL NodeBase *Baseget_p1() { return this->p1; }
    ALL NodeBase *Baseget_p2() { return this->p2; }
    ALL bool Baseis_max_force() { return this->force > this->max_force; }

    /////

    ALL void deactivate() { this->is_active = false; }
    ALL void update_force(float displacement) {
        this->force = this->factor * displacement;
    }
    ALL float get_force() { return this->force; }
    ALL float get_init_len() { return this->initial_length; }
    ALL bool get_is_active() { return this->is_active; }
    ALL void set_is_active(bool active) { this->is_active = active; }
    ALL NodeBase *get_p1() { return this->p1; }
    ALL NodeBase *get_p2() { return this->p2; }
    ALL bool is_max_force() { return this->force > this->max_force; }
};

class Spring: public SpringBase {
public:
  __device__ __host__ void dummy() {}
   ALL Spring(){classType = 1;}
};
