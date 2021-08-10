// Shader que ejemplifica la lógica básica del Shader de Unity (Propiedades, SubShader, Tags, CGPROGRAM...)

Shader "MyShaders/USB_simple_color"
{
    // ---------------------- Propiedades: Se exponen al editor ---------------------------//
    // Sintaxis: Nombre_variable(Nombre_inspector, tipo_de_dato) = valor
    Properties
    {
        // Propiedades de textura
        _MainTex ("Texture", 2D) = "white" {} // Textura
        _Reflection ("Reflection", Cube) = "black" {} // Reflexión
        _3DTexture ("3D Texture", 3D) = "white" {} // Textura 3D
        [Space(10)]
        
        // Propiedades de iluminación
        _Specular ("Specular", Range(0.0, 1.1)) = 0.3 // Luz especular
        _Factor ("Color Factor", Float) = 0.3 // Factor de color
        _Cid ("Color id", Int) = 2 // id color
        [Space(10)]

        // Propiedades para Colores y Vectores
        _Color ("Tint", Color) = (1, 1, 1, 1) // Color
        _VPos ("Vertex Position", Vector) = (0, 0, 0, 1) // Posición de vértices
        [Space(10)]
   
        // Propiedades Drawer (tipos de datos especiales)
        [Toggle] _Toggle ("Toggle", Float) = 0 // booleano
        
        [KeywordEnum(Off, Red, Blue)] 
        _Options ("Color Options", Float) = 0 // opciones
        
        [Enum(Off, 0, Front, 1, Back, 2)] 
        _Face ("Face Culling", Float) = 0 // enumerador
        
        [PowerSlider(3.0)] 
            _Brightness ("Brightness", Range (0.01, 1)) = 0.08 // slider

        [IntRange] 
            _Samples ("Samples", Range (0, 255)) = 100 // rango de números
        
        // Propiedades de Tags
        [Enum(UnityEngine.Rendering.BlendMode)] 
            _SrcBlend ("SrcFactor", Float) = 1
        [Enum(UnityEngine.Rendering.BlendMode)] 
            _DstBlend ("DstFactor", Float) = 1
    }
    // ---------------------- Subshader: Cada programa de shader (puede haber varios) ---------------------------//
    SubShader
    {
        // ---------------------- Tags: Asociaciones entre conjuntos de shaders ---------------------------//
        
        /// 1. Z - Buffer (Orden de dibujado en la CPU, de más lejado a más cercano
        Tags {"Queue" = "Transparent"} 

         // from 0 to 1499, default value 1000 
        //Tags {"Queue" = "Background"} 
        // from 1500 to 2399, default value 2000 
        //Tags {"Queue" = "Geometry"} 
        // from 2400 to 2699, default value 2450 
        //Tags {"Queue" = "AlphaTest"} 
        // from 2700 to 3599, default value 3000 
        //Tags {"Queue" = "Transparent"} 
        // from 3600 to 5000, default value 4000 
        //Tags {"Queue" = "Overlay"}
        
        /// 2. Tipo de Render (Opaco, Trasparente...)
        Tags { "RenderType" = "Transparent" } 
        
        // ----------- Blending: Operación de juntar 2 colores de pixel en uno solo. Se realiza después del fragment shader ------------//
        
        Blend [_SrcBlend] [_DstBlend]
        
        //Blend SrcAlpha OneMinusSrcAlpha     // common transparent blending 
        //Blend One One                       // additive blending color 
        //Blend OneMinusDstColor One          // mild additive blending color 
        //Blend DstColor Zero                 // multiplicative blending color 
        //Blend DstColor SrcColor             // multiplicative blending x2 
        //Blend SrcColor One                  // blending overlay 
        //Blend OneMinusSrcColor One          // soft light blending 
        //Blend Zero OneMinusSrcColor         // negative color blending
        
         // ----------------- AlphaToMask: Agrega el canal de Alpha duro (0-1) a las operaciones de Blending -----------------------//
        
         AlphaToMask On 
        
        // ------------------- ColorMask: Deja solo aquellos canales de color que especifiquemos al shader -------------------------//
        
        ColorMask RGBA
        
        //ColorMask R         // our object will look red.
        //ColorMask G         // our object will look green.
        //ColorMask B         // our object will look blue.
        //ColorMask A         // our object will be affected by transparency. 
        //ColorMask RG        // we can use two channel mixing.
        
        // ------------------- Culling: Caras visibles. Back: externas, Front: Internas, Off: ambas --------------------------------//
        
        Cull [_Face]
        
        // ------------------ Z-Writing: dibujado o no respecto a la profundidad objeto - cámara -----------------------------------//
        
        ZWrite Off
        
        // Se suele usar 'off' cuando existen trasparencias, ya que el render no sabe distinguir que caras van primero
        
        // ------------------ Z-Test: Comparaciones del Z-Buffer para saber que objetos se deben dibujar ---------------------------//
        
        ZTest LEqual
        
        //ZTest Less (<)         // Dibuja los objetos por delante.
        //ZTest Greater (>)      // Dibuja al objeto que está detrás.
        //ZTest LEqual (≤)       // Valor por defecto. Dibuja el objeto que está delante o a la misma distancia.
        //ZTest GEqual (≥)       // Dibuja el objeto que está detrás o a la misma distancia. 
        //ZTest Equal (==)       // Dibuja a los objetos que están a la misma distancia.
        //ZTest NotEqual (!=)    // Dibuja al objeto que no está a la misma distancia.
        //ZTest Always           // Dibuja todos los píxeles independientemente de la distancia de un objeto respecto a la cámara.
        
        LOD 100

        Pass
        {
            CGPROGRAM

            //----------------------------------------------- Tipos de Datos ----------------------------------------------------//

           // 1. Valores escalares
           
           //float: tipo de dato de alta precisión. 32 bits.  // Usado en cálculo de posiones en world-space, mapas UV, trigonometria...
           //half: tipo de dato de media precisión. 16 bits   // Usado en cálculo de vectores, direcciones, colores, posiciones object-space...
           //fixed (deprecated): tipo de dato de baja precisión. 11 bits // Operaciones simples

           //int: tipo de dato entero
           //sampler2D: tipo de dato de sampleo (mapeo) de textura y coordenadas UV
           //samplerCube

            // 2. Vectores

            //float2, float3, float4  // e.g. float3 uv = float3(1, 1, 1)
            //half2, half3, half4     // e.g halg4 color = half4(255,255,255,0)

            // 3. Matrices

            //float2x2, float3x3, float4x4
            //half2x2, half3x3, half4x4

            //float3x3 nombre = float3x3    // three rows and three columns 
            //(
            //    1, 0, 0,
            //    0, 1, 0,
            //    0, 0, 1
            //);

            //------------------------------------------------- Pragmas -------------------------------------------------------//
            
            // allow me to compile the "vert" function as a vertex shader. 
            #pragma vertex vert

            // allow me to compile the "frag" function as a fragment shader.
            #pragma fragment frag

            // make fog work
            #pragma multi_compile_fog

            // Toggle condition 
            #pragma shader_feature _ENABLE_ON
            #pragma multi_compile _OPTIONS_OFF _OPTIONS_RED  _OPTIONS_BLUE

            //------------------------------------------------- Include -------------------------------------------------------//
            // archivo de ayuda de Unity con funciones de utilidad para compilar HSLS
            // Ruta:  {unity install path}/Data/CGIncludes/UnityCG.cginc
            #include "UnityCG.cginc"

            //------------------------------------- Vertex Input y Vertex Output ----------------------------------------------//
            
            // appdata, corresponde a los datos de entrada del vertex shader (creada por defecto)
            // almacenaremos las propiedades de nuestros objetos (e.g. posición de los vértices, normales, etc)
            // sintaxis: vector[n] name : SEMANTIC[n];
            struct appdata
            {
                float4 vertex : POSITION; 
                float2 uv : TEXCOORD0;
            };

            // v2f, corresponde a los datos de salida del vertex shader (creada por defecto)
            // almacenaremos las propiedades rasterizadas para llevarlas al “fragment shader stage”.
            struct v2f
            {
                float2 uv : TEXCOORD0;
                UNITY_FOG_COORDS(1)
                float4 vertex : SV_POSITION;
            };

            // Semánticas + utilizadas
            
            //struct vertexInput (e.g. appdata)
            //{
            //    float4 vertPos : POSITION;  // Posición object-space
            //    float2 texCoord : TEXCOORD0; // Coordenadas de textura
            //    float3 normal : NORMAL0; // Normales
            //    float3 tangent : TANGENT0; // Tangentes
            //    float3 vertColor:  COLOR0; // Color
            //};

            //struct vertexOutput (e.g. v2f)
            //{
            //    float4 vertPos : SV_POSITION; // Posición object-space
            //    float2 texCoord : TEXCOORD0; // Coordenadas de textura
            //    float3 tangentWorld : TEXCOORD1; // Tangenetes
            //    float3 binormalWorld : TEXCOORD2; // Binormales
            //    float3 normalWorld : TEXCOORD3; // Normales
            //    float3 vertColor:  COLOR0; // Color
            //};

            //---------------------------------- Variables de conexión (uniform) ------------------------------------------//
            // Conectan las propiedades declaradas en el ShaderLab y expuestas al editor con el programa del shader para poder ser utilizadas
            sampler2D _MainTex;
            float4 _MainTex_ST;


            //----------------------------------------- Vertex Shader Stage ----------------------------------------------//
            // En esta etapa en donde los vértices son transformados desde un espacio 3D a una proyección bidimensional en la pantalla.
            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex); // transformación de los vértices del objeto desde object-space a clip-space
                o.uv = TRANSFORM_TEX(v.uv, _MainTex); //cumple la función de controlar el “tiling y offset” en las coordenadas UV de la textura.
                UNITY_TRANSFER_FOG(o,o.vertex);
                return o;
            }

            //----------------------------------------- Fragment Shader Stage ----------------------------------------------//
            // Va a procesar cada píxeles en la pantalla del computador en relación al objeto que estamos visualizando.
            half4 frag (v2f i) : SV_Target // SV_Target: color de salida del shader
            {
                // sample the texture
                half4 col = tex2D(_MainTex, i.uv);
                // apply fog
                UNITY_APPLY_FOG(i.fogCoord, col);
                return col;
            }
            
            ENDCG

        }
    }
    
    // El Fallback devuelve un shader por defecto en caso de que el subshader falle o no compile correctamente
    Fallback "Mobile / Unlit"
}
