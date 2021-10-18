#ifndef RotateCG
#define RotateCG

// FUNCIONES AQUÍ
float2 rotate(float2 uv, float center)
{
    float pivot = (center);

    float cosAngle = _CosTime.w;
    float sinAngle = _SinTime.w;
    float2x2 rot = float2x2
    (
        cosAngle, -sinAngle,
        sinAngle, cosAngle
    );

    float2 uvPiv = uv - pivot;

    float2 uvRot = mul(rot, uvPiv);

    return uvRot;
}

#endif