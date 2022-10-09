Shader "Multi Compile Shader Simple Toggle"
{
    Properties
    {
        [Toggle(_VAR_TEST_AAA)] _Use_TexAAA ("Use Tex AAA", int) = 0
        _TexAAA ("Tex AAA", 2D) = "white" {}
        [Toggle(_VAR_TEST_BBB)] _Use_TexBBB ("Use Tex BBB", int) = 0
        _TexBBB ("Tex BBB", 2D) = "white" {}
        [Toggle(_VAR_TEST_CCC)] _Use_TexCCC ("Use Tex CCC", int) = 0
        _TexCCC ("Tex CCC", 2D) = "white" {}
    }

    SubShader
    {
        Pass
        {
            CGPROGRAM

            #pragma vertex vert
            #pragma fragment frag

            #pragma multi_compile _ _VAR_TEST_AAA
            #pragma multi_compile _ _VAR_TEST_BBB
            #pragma multi_compile _ _VAR_TEST_CCC

            #include "UnityCG.cginc"

            sampler2D _TexAAA, _TexBBB, _TexCCC;
            float4 _TexAAA_ST, _TexBBB_ST, _TexCCC_ST;

            struct appdata
            {
                float4 position : POSITION;
                float4 texcoord : TEXCOORD0;
            };

            struct v2f
            {
                float4 position : SV_POSITION;
                float2 uvAAA    : TEXCOORD0;
                float2 uvBBB    : TEXCOORD1;
                float2 uvCCC    : TEXCOORD2;
            };

            v2f vert (appdata v)
            {
                v2f o;
                UNITY_INITIALIZE_OUTPUT(v2f, o);
                o.position = UnityObjectToClipPos(v.position);

                if (_VAR_TEST_AAA)
                {
                    o.uvAAA = TRANSFORM_TEX(v.texcoord, _TexAAA);
                }
                if (_VAR_TEST_BBB)
                {
                    o.uvBBB = TRANSFORM_TEX(v.texcoord, _TexBBB);
                }
                if (_VAR_TEST_CCC)
                {
                    o.uvCCC = TRANSFORM_TEX(v.texcoord, _TexCCC);
                }
                return o;
            }

            half4 frag (v2f i) : SV_Target
            {
                if (_VAR_TEST_AAA)
                {
                    return tex2D(_TexAAA, i.uvAAA) * half4(1, 0, 0, 1);
                }
                if (_VAR_TEST_BBB)
                {
                    return tex2D(_TexBBB, i.uvBBB) * half4(0, 1, 0, 1);
                }
                if (_VAR_TEST_CCC)
                {
                    return tex2D(_TexCCC, i.uvCCC) * half4(0, 0, 1, 1);
                }
                else
                {
                    return half4(1, 1, 1, 1);
                }
            }

            ENDCG
        }
    }
}