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



static inline Color3D Color3DMake(CGFloat inRed, CGFloat inGreen, CGFloat inBlue, CGFloat inAlpha)
{
    Color3D ret;
	ret.red = inRed;
	ret.green = inGreen;
	ret.blue = inBlue;
	ret.alpha = inAlpha;
    return ret;
}