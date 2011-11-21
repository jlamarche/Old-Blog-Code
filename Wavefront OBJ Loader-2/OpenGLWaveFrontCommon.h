#import <OpenGLES/EAGL.h>
#import <OpenGLES/ES1/gl.h>
#import <OpenGLES/ES1/glext.h>

@class OpenGLWaveFrontMaterial;

typedef struct {
	GLfloat	red;
	GLfloat	green;
	GLfloat	blue;
	GLfloat alpha;
} Color3D;

typedef struct {
	GLfloat	x;
	GLfloat y;
	GLfloat z;
} Vertex3D, Vector3D, Rotation3D;

typedef struct {
	GLushort	v1;
	GLushort	v2;
	GLushort	v3;
} Face3D;

typedef struct {
	Vertex3D v1;
	Vertex3D v2;
	Vertex3D v3;
} Triangle3D;

static inline Color3D Color3DMake(CGFloat inRed, CGFloat inGreen, CGFloat inBlue, CGFloat inAlpha)
{
    Color3D ret;
	ret.red = inRed;
	ret.green = inGreen;
	ret.blue = inBlue;
	ret.alpha = inAlpha;
    return ret;
}

static inline Vector3D Vector3DMake(CGFloat inX, CGFloat inY, CGFloat inZ)
{
	Vector3D ret;
	ret.x = inX;
	ret.y = inY;
	ret.z = inZ;
	return ret;
}
#define Vertex3DMake(x,y,z) (Vertex3D)Vector3DMake(x, y, z)

static inline Triangle3D Triangle3DMake(Vertex3D inV1, Vertex3D inV2, Vertex3D inV3)
{
	Triangle3D ret;
	ret.v1 = inV1;
	ret.v2 = inV2;
	ret.v3 = inV3;
	return ret;
}
static inline GLfloat vectorMagnitude(Vector3D vector)
{
	return sqrt((vector.x * vector.x) + (vector.y * vector.y) + (vector.z * vector.z)); 
}
static inline void vectorNormalize(Vector3D *vector)
{
	GLfloat vecMag = vectorMagnitude(*vector);
	if ( vecMag == 0.0 )
	{
		vector->x /= 1.0;
		vector->y /= 0.0;
		vector->z /= 0.0;
	}
	vector->x /= vecMag;
	vector->y /= vecMag;
	vector->z /= vecMag;
}

static inline GLfloat vectorDotProduct(Vector3D vector1, Vector3D vector2)
{		
	return vector1.x*vector2.x + vector1.y*vector2.y + vector1.z*vector2.z;
	
}
static inline Vector3D vectorCrossProduct(Vector3D vector1, Vector3D vector2)
{
	Vector3D ret;
	ret.x = (vector1.y * vector2.z) - (vector1.z * vector2.y);
	ret.y = (vector1.z * vector2.x) - (vector1.x * vector2.z);
	ret.z = (vector1.x * vector2.y) - (vector1.y * vector2.x);
	return ret;
}
static inline Vector3D Vector3DMakeWithStartAndEndPoints(Vertex3D start, Vertex3D end)
{
	Vector3D ret;
	ret.x = end.x - start.x;
	ret.y = end.y - start.y;
	ret.z = end.z - start.z;
	vectorNormalize(&ret);
	return ret;
}

static inline Vector3D Triangle3DCalculateSurfaceNormal(Triangle3D triangle)
{
	Vector3D u = Vector3DMakeWithStartAndEndPoints(triangle.v2, triangle.v1);
	Vector3D v = Vector3DMakeWithStartAndEndPoints(triangle.v3, triangle.v1);
	
	Vector3D ret;
	ret.x = (u.y * v.z) - (u.z * v.y);
	ret.y = (u.z * v.x) - (u.x * v.z);
	ret.z = (u.x * v.y) - (u.y * v.x);
	return ret;
}
static inline Vector3D Vector3DAdd(Vector3D vector1, Vector3D vector2)
{
	Vector3D ret;
	ret.x = vector1.x + vector2.x;
	ret.y = vector1.y + vector2.y;
	ret.z = vector1.z + vector2.z;
	return ret;
}
static inline void Vector3DFlip (Vector3D *vector)
{
		vector->x = -vector->x;
		vector->y = -vector->y;
		vector->z = -vector->z;
}
