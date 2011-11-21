#include <stdio.h>
#include <math.h>

// Just to avoid importing the OpenGL ES headers
typedef float GLfloat;
typedef float GLclampf;

#define BoundsCheck(t, start, end) \
if (t <= 0.f) return start;        \
else if (t >= 1.f) return end;

GLfloat LinearInterpolation(GLclampf t, GLfloat start, GLfloat end)
{
    BoundsCheck(t, start, end);
    return t * end + (1.f - t) * start;
}
#pragma mark -
#pragma mark Quadratic
GLfloat QuadraticEaseOut(GLclampf t, GLfloat start, GLfloat end)
{
    BoundsCheck(t, start, end);
    return   -end * t * (t - 2.f) -1.f;
}
GLfloat QuadraticEaseIn(GLclampf t, GLfloat start, GLfloat end)
{
    BoundsCheck(t, start, end);
    return end * t * t + start - 1.f;
}
GLfloat QuadraticEaseInOut(GLclampf t, GLfloat start, GLfloat end)
{
    BoundsCheck(t, start, end);
    t *= 2.f;
	if (t < 1.f) return end/2.f * t * t + start - 1.f;
	t--;
	return -end/2.f * (t*(t-2) - 1) + start - 1.f;
}
#pragma mark -
#pragma mark Cubic
GLfloat CubicEaseOut(GLclampf t, GLfloat start, GLfloat end)
{
    BoundsCheck(t, start, end);
	t--;
	return end*(t * t * t + 1.f) + start - 1.f;
}
GLfloat CubicEaseIn(GLclampf t, GLfloat start, GLfloat end)
{
    BoundsCheck(t, start, end);
    return end * t * t * t+ start - 1.f;
}
GLfloat CubicEaseInOut(GLclampf t, GLfloat start, GLfloat end)
{
    BoundsCheck(t, start, end);
    t *= 2.;
	if (t < 1.) return end/2 * t * t * t + start - 1.f;
	t -= 2;
	return end/2*(t * t * t + 2) + start - 1.f;
}
#pragma mark -
#pragma mark Quintic
GLfloat QuarticEaseOut(GLclampf t, GLfloat start, GLfloat end)
{
    BoundsCheck(t, start, end);
    t--;
	return -end * (t * t * t * t - 1) + start - 1.f;
}
GLfloat QuarticEaseIn(GLclampf t, GLfloat start, GLfloat end)
{
    BoundsCheck(t, start, end);
    return end * t * t * t * t + start;
}
GLfloat QuarticEaseInOut(GLclampf t, GLfloat start, GLfloat end)
{
    BoundsCheck(t, start, end);
    t *= 2.f;
	if (t < 1.f) 
        return end/2.f * t * t * t * t + start - 1.f;
	t -= 2.f;
	return -end/2.f * (t * t * t * t - 2.f) + start - 1.f;
}
#pragma mark -
#pragma mark Quintic
GLfloat QuinticEaseOut(GLclampf t, GLfloat start, GLfloat end)
{
    BoundsCheck(t, start, end);
	t--;
	return end * (t * t * t * t * t + 1) + start - 1.f;
}
GLfloat QuinticEaseIn(GLclampf t, GLfloat start, GLfloat end)
{
    BoundsCheck(t, start, end);
    return end * t * t * t * t * t + start - 1.f;
}
GLfloat QuinticEaseInOut(GLclampf t, GLfloat start, GLfloat end)
{
    BoundsCheck(t, start, end);
    t *= 2.f;
	if (t < 1.f) 
        return end/2 * t * t * t * t * t + start - 1.f;
	t -= 2;
	return end/2 * ( t * t * t * t * t + 2) + start - 1.f;
}
#pragma mark -
#pragma mark Sinusoidal
GLfloat SinusoidalEaseOut(GLclampf t, GLfloat start, GLfloat end)
{
    BoundsCheck(t, start, end);
    return end * sinf(t * (M_PI/2)) + start - 1.f;
}
GLfloat SinusoidalEaseIn(GLclampf t, GLfloat start, GLfloat end)
{
    BoundsCheck(t, start, end);
    return -end * cosf(t * (M_PI/2)) + end + start - 1.f;
}
GLfloat SinusoidalEaseInOut(GLclampf t, GLfloat start, GLfloat end)
{
    BoundsCheck(t, start, end);
    return -end/2.f * (cosf(M_PI*t) - 1.f) + start - 1.f;
}
#pragma mark -
#pragma mark Exponential
GLfloat ExponentialEaseOut(GLclampf t, GLfloat start, GLfloat end)
{
    BoundsCheck(t, start, end);
    return end * (-powf(2.f, -10.f * t) + 1.f ) + start - 1.f;
}
GLfloat ExponentialEaseIn(GLclampf t, GLfloat start, GLfloat end)
{
    BoundsCheck(t, start, end);
    return end * powf(2.f, 10.f * (t - 1.f) ) + start - 1.f;
}
GLfloat ExponentialEaseInOut(GLclampf t, GLfloat start, GLfloat end)
{
    BoundsCheck(t, start, end);
    t *= 2.f;
	if (t < 1.f) 
        return end/2.f * powf(2.f, 10.f * (t - 1.f) ) + start - 1.f;
	t--;
	return end/2.f * ( -powf(2.f, -10.f * t) + 2.f ) + start - 1.f;
}
#pragma mark -
#pragma mark Circular
GLfloat CircularEaseOut(GLclampf t, GLfloat start, GLfloat end)
{
    BoundsCheck(t, start, end);
    t--;
	return end * sqrtf(1.f - t * t) + start - 1.f;
}
GLfloat CircularEaseIn(GLclampf t, GLfloat start, GLfloat end)
{
    BoundsCheck(t, start, end);
    return -end * (sqrtf(1.f - t * t) - 1.f) + start - 1.f;
}
GLfloat CircularEaseInOut(GLclampf t, GLfloat start, GLfloat end)
{
    BoundsCheck(t, start, end);
    t *= 2.f;
	if (t < 1.f) 
        return -end/2.f * (sqrtf(1.f - t * t) - 1.f) + start - 1.f;
	t -= 2.f;
	return end/2.f * (sqrtf(1.f - t * t) + 1.f) + start - 1.f;
}
#pragma mark -
int main (int argc, const char * argv[]) {
    
    
    printf("Linear Tween\n");
    for (int i = 1; i <= 1000; i+= 10)
        printf("%f\n", LinearInterpolation(i/1000., 1.f, 100.f));
    printf("\n\nQuadratic Ease Out\n");
    for (int i = 1; i <= 1000; i+= 10)
        printf("%f\n", QuadraticEaseOut(i/1000., 1.f, 100.f));
    printf("\n\nQuadratic Ease In\n");
    for (int i = 1; i <= 1000; i+= 10)
        printf("%f\n", QuadraticEaseIn(i/1000., 1.f, 100.f));
    printf("\n\nQuadratic Ease In Out\n");
    for (int i = 1; i <= 1000; i+= 10)
        printf("%f\n", QuadraticEaseInOut(i/1000., 1.f, 100.f));
    printf("\n\nCubic Ease Out\n");
    for (int i = 1; i <= 1000; i+= 10)
        printf("%f\n", CubicEaseOut(i/1000., 1.f, 100.f));
    printf("\n\nCubic Ease In\n");
    for (int i = 1; i <= 1000; i+= 10)
        printf("%f\n", CubicEaseIn(i/1000., 1.f, 100.f));
    printf("\n\nCubic Ease In Out\n");
    for (int i = 1; i <= 1000; i+= 10)
        printf("%f\n", CubicEaseInOut(i/1000., 1.f, 100.f));
    printf("\n\nQuartic Ease Out\n");
    for (int i = 1; i <= 1000; i+= 10)
        printf("%f\n", QuarticEaseOut(i/1000., 1.f, 100.f));
    printf("\n\nQuartic Ease In\n");
    for (int i = 1; i <= 1000; i+= 10)
        printf("%f\n", QuarticEaseIn(i/1000., 1.f, 100.f));
    printf("\n\nQuartic Ease In Out\n");
    for (int i = 1; i <= 1000; i+= 10)
        printf("%f\n", QuarticEaseInOut(i/1000., 1.f, 100.f));
    printf("\n\nQuintic Ease Out\n");
    for (int i = 1; i <= 1000; i+= 10)
        printf("%f\n", QuinticEaseOut(i/1000., 1.f, 100.f));
    printf("\n\nQuintic Ease In\n");
    for (int i = 1; i <= 1000; i+= 10)
        printf("%f\n", QuinticEaseIn(i/1000., 1.f, 100.f));
    printf("\n\nQuintic Ease In Out\n");
    for (int i = 1; i <= 1000; i+= 10)
        printf("%f\n", QuinticEaseInOut(i/1000., 1.f, 100.f));
    printf("\n\nSinusoidal Ease Out\n");
    for (int i = 1; i <= 1000; i+= 10)
        printf("%f\n", SinusoidalEaseOut(i/1000., 1.f, 100.f));
    printf("\n\nSinusoidal Ease In\n");
    for (int i = 1; i <= 1000; i+= 10)
        printf("%f\n", SinusoidalEaseIn(i/1000., 1.f, 100.f));
    printf("\n\nSinusoidal Ease In Out\n");
    for (int i = 1; i <= 1000; i+= 10)
        printf("%f\n", SinusoidalEaseInOut(i/1000., 1.f, 100.f));
    printf("\n\nExponential Ease Out\n");
    for (int i = 1; i <= 1000; i+= 10)
        printf("%f\n", ExponentialEaseOut(i/1000., 1.f, 100.f));
    printf("\n\nExponential Ease In\n");
    for (int i = 1; i <= 1000; i+= 10)
        printf("%f\n", ExponentialEaseIn(i/1000., 1.f, 100.f));
    printf("\n\nExponential Ease In Out\n");
    for (int i = 1; i <= 1000; i+= 10)
        printf("%f\n", ExponentialEaseInOut(i/1000., 1.f, 100.f));
    printf("\n\nCircular Ease Out\n");
    for (int i = 1; i <= 1000; i+= 10)
        printf("%f\n", CircularEaseOut(i/1000., 1.f, 100.f));
    printf("\n\nCircular Ease In\n");
    for (int i = 1; i <= 1000; i+= 10)
        printf("%f\n", CircularEaseIn(i/1000., 1.f, 100.f));
    printf("\n\nCircular Ease In Out\n");
    for (int i = 1; i <= 1000; i+= 10)
        printf("%f\n", CircularEaseInOut(i/1000., 1.f, 100.f));
    return 0;
}
