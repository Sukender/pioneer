#ifndef _MODELBODY_H
#define _MODELBODY_H

#include "Body.h"
#include "vector3.h"
#include "matrix4x4.h"
#include "sbre/sbre.h"
#include <vector>
class ObjMesh;
class CollMeshSet;
class Geom;

class ModelBody: public Body {
public:
	OBJDEF(ModelBody, Body, MODELBODY);
	ModelBody();
	virtual ~ModelBody();
	void SetPosition(vector3d p);
	virtual void SetRotMatrix(const matrix4x4d &r);
	vector3d GetPosition() const;
	virtual double GetBoundingRadius() const;
	void TransformToModelCoords(const Frame *camFrame);
	void GetRotMatrix(matrix4x4d &m) const;
	virtual void SetFrame(Frame *f);
	// to remove from simulation for a period
	virtual void Disable();
	virtual void Enable();
	void GetAabb(Aabb &aabb) const;
	Geom *GetGeom() { return m_geom; }
	int GetSbreModel() const { return m_sbreModel; }
	
	void TriMeshUpdateLastPos(const matrix4x4d &currentTransform);
	void SetModel(const char *sbreModelName, bool isStatic = false);

	void RenderSbreModel(const vector3d &viewCoords, const matrix4x4d &viewTransform, ObjParams *params);
protected:
	virtual void Save();
	virtual void Load();
private:
	const CollMeshSet *m_collMeshSet;
	int m_sbreModel;
	bool m_isStatic;
	Geom *m_geom;
};

#endif /* _MODELBODY_H */
