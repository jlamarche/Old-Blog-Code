#if TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR || TARGET_OS_EMBEDDED
#import <OpenGLES/EAGL.h>
#import <OpenGLES/ES1/gl.h>
#import <OpenGLES/ES1/glext.h>
#else
#import <OpenGL/OpenGL.h>
#endif
@class OpenGLWaveFrontMaterial;

#pragma mark -
#pragma mark Color3D
#pragma mark -
typedef struct {
	GLfloat	red;
	GLfloat	green;
	GLfloat	blue;
	GLfloat alpha;
} Color3D;
static inline Color3D Color3DMake(CGFloat inRed, CGFloat inGreen, CGFloat inBlue, CGFloat inAlpha)
{
    Color3D ret;
	ret.red = inRed;
	ret.green = inGreen;
	ret.blue = inBlue;
	ret.alpha = inAlpha;
    return ret;
}
static inline void Color3DSet(Color3D *color, CGFloat inRed, CGFloat inGreen, CGFloat inBlue, CGFloat inAlpha)
{
    color->red = inRed;
    color->green = inGreen;
    color->blue = inBlue;
    color->alpha = inAlpha;
}
#pragma mark -
#pragma mark Vertex3D
#pragma mark -
typedef struct {
	GLfloat	x;
	GLfloat y;
	GLfloat z;
} Vertex3D;

static inline Vertex3D Vertex3DMake(CGFloat inX, CGFloat inY, CGFloat inZ)
{
	Vertex3D ret;
	ret.x = inX;
	ret.y = inY;
	ret.z = inZ;
	return ret;
}
static inline void Vertex3DSet(Vertex3D *vertex, CGFloat inX, CGFloat inY, CGFloat inZ)
{
    vertex->x = inX;
    vertex->y = inY;
    vertex->z = inZ;
}
#pragma mark -
#pragma mark Vector3D
#pragma mark -
typedef Vertex3D Vector3D;
#define Vector3DMake(x,y,z) (Vector3D)Vertex3DMake(x, y, z)
#define Vector3DSet(vector,x,y,z) Vertex3DSet(vector, x, y, z)
static inline GLfloat Vector3DMagnitude(Vector3D vector)
{
	return sqrtf((vector.x * vector.x) + (vector.y * vector.y) + (vector.z * vector.z)); 
}
static inline void Vector3DNormalize(Vector3D *vector)
{
	GLfloat vecMag = Vector3DMagnitude(*vector);
	if ( vecMag == 0.0 )
	{
		vector->x = 1.0;
		vector->y = 0.0;
		vector->z = 0.0;
        return;
	}
	vector->x /= vecMag;
	vector->y /= vecMag;
	vector->z /= vecMag;
}
static inline GLfloat Vector3DDotProduct(Vector3D vector1, Vector3D vector2)
{		
	return vector1.x*vector2.x + vector1.y*vector2.y + vector1.z*vector2.z;
	
}
static inline Vector3D Vector3DCrossProduct(Vector3D vector1, Vector3D vector2)
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
	Vector3DNormalize(&ret);
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
#pragma mark -
#pragma mark Rotation3D
#pragma mark -
// A Rotation3D is just a Vertex3D used to store three angles (pitch, yaw, roll) instead of cartesian coordinates. 
// For simplicity, we just reuse the Vertex3D, even though the member names should probably be either xRot, yRot, 
// and zRot, or else pitch, yaw, roll. 
typedef Vertex3D Rotation3D;
#define Rotation3DMake(x,y,z) (Rotation3D)Vertex3DMake(x, y, z)
#pragma mark -
#pragma mark Face3D
#pragma mark -
// Face3D is used to hold three integers which will be integer index values to another array
typedef struct {
	GLushort	v1;
	GLushort	v2;
	GLushort	v3;
} Face3D;
static inline Face3D Face3DMake(int v1, int v2, int v3)
{
	Face3D ret;
	ret.v1 = v1;
	ret.v2 = v2;
	ret.v3 = v3;
	return ret;
}
#pragma mark -
#pragma mark Triangle3D
#pragma mark -
typedef struct {
	Vertex3D v1;
	Vertex3D v2;
	Vertex3D v3;
} Triangle3D;
static inline Triangle3D Triangle3DMake(Vertex3D inV1, Vertex3D inV2, Vertex3D inV3)
{
	Triangle3D ret;
	ret.v1 = inV1;
	ret.v2 = inV2;
	ret.v3 = inV3;
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
#pragma mark -
#pragma mark VertexTextureCombinations
#pragma mark -
// This implements a binary search tree that will help us determine which vertices need to be duplicated. In
// OpenGL, each vertex has to have one and only one set of texture coordinates, so if a single vertex is shared
// by multiple triangles and has different texture coordinates in each, those vertices need to be duplicated
// so that there is one copy of that vertex for every distinct set of texture coordinates.

// This works with index values, not actual Vertex3D values, for speed, and because that's the way the 
// OBJ file format tells us about them
//
// An actualVertex value of UINT_MAX means that the actual integer value hasn't been determined yet. 
typedef struct {
	GLuint	originalVertex;
	GLuint	textureCoords;
	GLuint	actualVertex;
	void	*greater;
	void	*lesser;
	
} VertexTextureIndex;
static inline VertexTextureIndex * VertexTextureIndexMake (GLuint inVertex, GLuint inTextureCoords, GLuint inActualVertex)
{
	VertexTextureIndex *ret = malloc(sizeof(VertexTextureIndex));
	ret->originalVertex = inVertex;
	ret->textureCoords = inTextureCoords;
	ret->actualVertex = inActualVertex;
	ret->greater = NULL;
	ret->lesser = NULL;
	return ret;
}
#define VertexTextureIndexMakeEmpty(x,y) VertexTextureIndexMake(x, y, UINT_MAX)
// recursive search function - looks for a match for a given combination of vertex and 
// texture coordinates. If not found, returns UINT_MAX
static inline GLuint VertexTextureIndexMatch(VertexTextureIndex *node, GLuint matchVertex, GLuint matchTextureCoords)
{
	if (node->originalVertex == matchVertex && node->textureCoords == matchTextureCoords)
		return node->actualVertex;
	
	if (node->greater != NULL)
	{
		GLuint greaterIndex = VertexTextureIndexMatch(node->greater, matchVertex, matchTextureCoords);
		if (greaterIndex != UINT_MAX)
			return greaterIndex;
	}
	
	if (node->lesser != NULL)
	{
		GLuint lesserIndex = VertexTextureIndexMatch(node->lesser, matchVertex, matchTextureCoords);
		return lesserIndex;
	}
	return UINT_MAX;
}
static inline VertexTextureIndex * VertexTextureIndexAddNode(VertexTextureIndex *node, GLuint newVertex, GLuint newTextureCoords)
{
	// If requested new node matches the one being added to, then don't add, just return pointer to match
	if (node->originalVertex == newVertex && node->textureCoords == newTextureCoords)
		return node;
	if (node->originalVertex > newVertex || (node->originalVertex == newVertex && node->textureCoords > newTextureCoords))
	{
		if (node->lesser != NULL)
			return VertexTextureIndexAddNode(node->lesser, newVertex, newTextureCoords);
		else
		{
			VertexTextureIndex *newNode = VertexTextureIndexMakeEmpty(newVertex, newTextureCoords);
			node->lesser = newNode;
			return node->lesser;
		}
	}
	else
	{
		if (node->greater != NULL)
			return VertexTextureIndexAddNode(node->greater, newVertex, newTextureCoords);
		else
		{
			VertexTextureIndex *newNode = VertexTextureIndexMakeEmpty(newVertex, newTextureCoords);
			node->greater = newNode;
			return node->greater;
		}	
	}
	return NULL; // shouldn't ever reach here.
}
static inline BOOL VertexTextureIndexContainsVertexIndex(VertexTextureIndex *node, GLuint matchVertex)
{
	if (node->originalVertex == matchVertex)
		return YES;
	
	BOOL greaterHas = NO;
	BOOL lesserHas = NO;
	
	if (node->greater != NULL)
		greaterHas = VertexTextureIndexContainsVertexIndex(node->greater, matchVertex);
	if (node->lesser != NULL)
		lesserHas = VertexTextureIndexContainsVertexIndex(node->lesser, matchVertex);
	return lesserHas || greaterHas;
}
static inline void VertexTextureIndexFree(VertexTextureIndex *node)
{
	if (node != NULL)
	{
		if (node->greater != NULL)
			VertexTextureIndexFree(node->greater);
		if (node->lesser != NULL)
			VertexTextureIndexFree(node->lesser);
		free(node);
	}
	
}
static inline GLuint VertexTextureIndexCountNodes(VertexTextureIndex *node)
{
	GLuint ret = 0;  
	
	if (node)
	{
		ret++; // count this node
		
		// Add the children
		if (node->greater != NULL)
			ret += VertexTextureIndexCountNodes(node->greater);
		if (node->lesser != NULL)
			ret += VertexTextureIndexCountNodes(node->lesser);
	}
	return ret;
}
#pragma mark -
#pragma mark Missing GLUT Functionality
// This is a modified version of the function of the same name from 
// the Mesa3D project ( http://mesa3d.org/ ), which is  licensed
// under the MIT license, which allows use, modification, and 
// redistribution
static inline void gluLookAt(GLfloat eyex, GLfloat eyey, GLfloat eyez,
							 GLfloat centerx, GLfloat centery, GLfloat centerz,
							 GLfloat upx, GLfloat upy, GLfloat upz)
{
	GLfloat m[16];
	GLfloat x[3], y[3], z[3];
	GLfloat mag;
	
	/* Make rotation matrix */
	
	/* Z vector */
	z[0] = eyex - centerx;
	z[1] = eyey - centery;
	z[2] = eyez - centerz;
	mag = sqrtf(z[0] * z[0] + z[1] * z[1] + z[2] * z[2]);
	if (mag) {			/* mpichler, 19950515 */
		z[0] /= mag;
		z[1] /= mag;
		z[2] /= mag;
	}
	
	/* Y vector */
	y[0] = upx;
	y[1] = upy;
	y[2] = upz;
	
	/* X vector = Y cross Z */
	x[0] = y[1] * z[2] - y[2] * z[1];
	x[1] = -y[0] * z[2] + y[2] * z[0];
	x[2] = y[0] * z[1] - y[1] * z[0];
	
	/* Recompute Y = Z cross X */
	y[0] = z[1] * x[2] - z[2] * x[1];
	y[1] = -z[0] * x[2] + z[2] * x[0];
	y[2] = z[0] * x[1] - z[1] * x[0];
	
	/* mpichler, 19950515 */
	/* cross product gives area of parallelogram, which is < 1.0 for
	 * non-perpendicular unit-length vectors; so normalize x, y here
	 */
	
	mag = sqrtf(x[0] * x[0] + x[1] * x[1] + x[2] * x[2]);
	if (mag) {
		x[0] /= mag;
		x[1] /= mag;
		x[2] /= mag;
	}
	
	mag = sqrtf(y[0] * y[0] + y[1] * y[1] + y[2] * y[2]);
	if (mag) {
		y[0] /= mag;
		y[1] /= mag;
		y[2] /= mag;
	}
	
#define M(row,col)  m[col*4+row]
	M(0, 0) = x[0];
	M(0, 1) = x[1];
	M(0, 2) = x[2];
	M(0, 3) = 0.0;
	M(1, 0) = y[0];
	M(1, 1) = y[1];
	M(1, 2) = y[2];
	M(1, 3) = 0.0;
	M(2, 0) = z[0];
	M(2, 1) = z[1];
	M(2, 2) = z[2];
	M(2, 3) = 0.0;
	M(3, 0) = 0.0;
	M(3, 1) = 0.0;
	M(3, 2) = 0.0;
	M(3, 3) = 1.0;
#undef M
	glMultMatrixf(m);
	
	/* Translate Eye to Origin */
	glTranslatef(-eyex, -eyey, -eyez);
	
}

