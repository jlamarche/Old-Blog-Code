#!BPY

"""
Name: 'Objective-C Header (.h)'
Blender: 244
Group: 'Export'
Tooltip: 'Exports header file for use with the OpenGL ES template for iPhone available from http://iphonedevelopment.blogspot.com/'
"""
import Blender
from Blender import Mathutils
from Blender.Mathutils import *
import bpy
import os
    
def average_normals(faces):
    ret = Mathutils.Vector(0.0, 0.0, 0.0)
    for face in faces:
        normal = face.no
        ret.x = ret.x + normal.x
        ret.y = ret.y + normal.y
        ret.z = ret.z + normal.z
    
    ret.x = ret.x / len(faces)
    ret.y = ret.y / len(faces)
    ret.z = ret.z / len(faces)
    return ret

def write_obj(filepath):    
    out = file(filepath, 'w')
    sce = bpy.data.scenes.active
    ob = sce.objects.active
    mesh = ob.getData(mesh=1)
    objectname = ob.getData(True)
    basename = objectname[0].capitalize() + objectname[1:]
    findex = 0
    
    out.write('#import "OpenGLCommon.h"\n\n\n')
    out.write('static const TexturedVertexData3D %sVertexData[] = {\n' % basename)
    for face in mesh.faces:
        vert_index = 0
        for vert in face.v:
            out.write('\t{/*v:*/{%f, %f, %f}, ' % (vert.co.x, vert.co.y, vert.co.z) )
            out.write('/*n:*/{%f, %f, %f}, ' % (vert.no.x, vert.no.y, vert.no.z))
            out.write('/*t:*/{%f, %f}' % ( face.uv[vert_index].x, face.uv[vert_index].y ) )
            out.write('},\n')
            vert_index = vert_index + 1
    out.write('};\n\n')

    out.write('#define k%sNumberOfVertices\t%i\n' % (basename, len(mesh.faces) * 3) )

    out.write('// Drawing Code:')
    out.write('// glEnableClientState(GL_VERTEX_ARRAY);\n')
    out.write('// glEnableClientState(GL_TEXTURE_COORD_ARRAY);\n')
    out.write('// glEnableClientState(GL_NORMAL_ARRAY);\n')
    out.write('// glVertexPointer(3, GL_FLOAT, sizeof(TexturedVertexData3D), &%sVertexData[0].vertex);\n' % basename)
    out.write('// glNormalPointer(GL_FLOAT, sizeof(TexturedVertexData3D), &%sVertexData[0].normal);\n' % basename)
    out.write('// glTexCoordPointer(2, GL_FLOAT, sizeof(TexturedVertexData3D), &%sVertexData[0].texCoord);\n' % basename)
    out.write('// glDrawArrays(GL_TRIANGLES, 0, k%sNumberOfVertices);\n' % basename)
    out.write('// glDisableClientState(GL_VERTEX_ARRAY);\n')
    out.write('// glDisableClientState(GL_TEXTURE_COORD_ARRAY);\n')
    out.write('// glDisableClientState(GL_NORMAL_ARRAY);\n\n\n')
    
    out.close()

filename = os.path.splitext(Blender.Get('filename'))[0]
Blender.Window.FileSelector(write_obj, "Export", '%s.h' % filename)