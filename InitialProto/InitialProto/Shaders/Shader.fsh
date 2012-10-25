//
//  Shader.fsh
//  InitialProto
//
//  Created by Eric Zhang on 10/24/12.
//  Copyright (c) 2012 GutShotGames. All rights reserved.
//

varying lowp vec4 colorVarying;

void main()
{
    gl_FragColor = colorVarying;
}
