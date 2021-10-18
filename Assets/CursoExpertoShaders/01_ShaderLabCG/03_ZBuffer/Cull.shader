Shader "Custom/Cull"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
    }
    SubShader
    {          
        // SE PUEDE ESCRIBIR AQUÍ  
        // Cull Back
        // Cull Front
         Cull Off

        Pass
        {       
            // TAMBIÉN SE PUEDE ESCRIBIR AQUÍ

            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            struct appdata  // vertexInput
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f  // vertexOutput
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex; // textura
            float4 _MainTex_ST; // tiling y offset

            v2f vert (appdata v)    // vertexShader
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target // fragmentShader
            {
                // sample the texture
                fixed4 col = tex2D(_MainTex, i.uv);
                return col;
            }
            ENDCG
        }
    }
}
