﻿//////////////////////////////////////////////////////
// MK Toon URP Particles Unlit + Refraction			//
//					                                //
// Created by Michael Kremmel                       //
// www.michaelkremmel.de                            //
// Copyright © 2021 All rights reserved.            //
//////////////////////////////////////////////////////

Shader "MK/Toon/URP/Particles/Unlit + Refraction"
{
	Properties
	{
		/////////////////
		// Options     //
		/////////////////
		[Enum(MK.Toon.SurfaceRefraction)] _Surface ("", int) = 1
		 _Blend ("", int) = 0
		[Toggle] _AlphaClipping ("", int) = 0
		[HideInInspector] [Enum(MK.Toon.RenderFace)] _RenderFace ("", int) = 2

		/////////////////
		// Input       //
		/////////////////
		[MainColor] _AlbedoColor ("", Color) = (1,1,1,1)
		_AlphaCutoff ("", Range(0, 1)) = 0.5
		[MainTexture] _AlbedoMap ("", 2D) = "white" {}

		/////////////////
		// Stylize     //
		/////////////////
		_Contrast ("", Float) = 1.0
		[MKToonSaturation] _Saturation ("", Float) = 1.0
		[MKToonBrightness] _Brightness ("",  Float) = 1
		[Enum(MK.Toon.ColorGrading)] _ColorGrading ("", int) = 0
		[Toggle] _VertexAnimationStutter ("", int) = 0
		[Enum(MK.Toon.VertexAnimation)] _VertexAnimation ("", int) = 0
        _VertexAnimationIntensity ("", Range(0, 1)) = 0.05
		_VertexAnimationMap ("", 2D) = "white" {}
        [MKToonVector3Drawer] _VertexAnimationFrequency ("", Vector) = (2.5, 2.5, 2.5, 1)
		[Enum(MK.Toon.Dissolve)] _Dissolve ("", int) = 0
		_DissolveMapScale ("", Float) = 1
		_DissolveMap ("", 2D) = "white" {}
		_DissolveAmount ("", Range(0.0, 1.0)) = 0.5
		_DissolveBorderSize ("", Range(0.0, 1.0)) = 0.25
		_DissolveBorderRamp ("", 2D) = "white" {}
		[HDR] _DissolveBorderColor ("", Color) = (1, 1, 1, 1)

		/////////////////
		// Advanced    //
		/////////////////
		[HideInInspector] [Enum(MK.Toon.BlendFactor)] _BlendSrc ("", int) = 1
		[HideInInspector] [Enum(MK.Toon.BlendFactor)] _BlendDst ("", int) = 0
		[Enum(MK.Toon.ZWrite)] _ZWrite ("", int) = 0
		[Enum(MK.Toon.ZTest)] _ZTest ("", int) = 4.0
		[MKToonRenderPriority] _RenderPriority ("", Range(-50, 50)) = 0.0

		[Enum(MK.Toon.Stencil)] _Stencil ("", Int) = 1
		[MKToonStencilRef] _StencilRef ("", Range(0, 255)) = 0
		[MKToonStencilReadMask] _StencilReadMask ("", Range(0, 255)) = 255
		[MKToonStencilWriteMask] _StencilWriteMask ("", Range(0, 255)) = 255
		[Enum(MK.Toon.StencilComparison)] _StencilComp ("", Int) = 8
		[Enum(MK.Toon.StencilOperation)] _StencilPass ("", Int) = 0
		[Enum(MK.Toon.StencilOperation)] _StencilFail ("", Int) = 0
		[Enum(MK.Toon.StencilOperation)] _StencilZFail ("", Int) = 0
		
		/////////////////
		// Particles   //
		/////////////////
		[Toggle] _Flipbook ("", Float) = 0.0
		[Toggle] _SoftFade ("", Float) = 0.0
		[MKToonSoftFadeNearDistance] _SoftFadeNearDistance ("", Float) = 0.0
        [MKToonSoftFadeFarDistance] _SoftFadeFarDistance ("", Float) = 1.0
		_SoftFadeModeParams("", Vector) = (0,0,0,0)
		[Enum(MK.Toon.ColorBlend)] _ColorBlend ("", Float) = 0.0
		[Toggle] _CameraFade ("", Float) = 0.0
		_CameraFadeParams("", Vector) = (0,0,0,0)
        [MKToonCameraFadeNearDistance] _CameraFadeNearDistance ("", Float) = 1.0
        [MKToonCameraFadeFarDistance] _CameraFadeFarDistance ("", Float) = 2.0

		/////////////////
		// Refraction  //
		/////////////////
		_RefractionDistortionMapScale ("", Float) = 1.0
		[Normal] _RefractionDistortionMap ("", 2D) = "bump" {}
		_RefractionDistortion ("", Float) = 0.1
		_IndexOfRefraction ("", Range(0, 0.5)) = 0.0
		_RefractionDistortionFade ("", Range(0.0, 1.0)) = 0.5

		/////////////////
		// Editor Only //
		/////////////////
		[HideInInspector] _Initialized ("", int) = 0
        [HideInInspector] _OptionsTab ("", int) = 1
		[HideInInspector] _InputTab ("", int) = 1
		[HideInInspector] _StylizeTab ("", int) = 0
		[HideInInspector] _AdvancedTab ("", int) = 0
		[HideInInspector] _ParticlesTab ("", int) = 0
		[HideInInspector] _RefractionTab ("", int) = 0

		/////////////////
		// System	   //
		/////////////////
		[HideInInspector] _Cutoff ("", Range(0, 1)) = 0.5
		[HideInInspector] _MainTex ("", 2D) = "white" {}
	}
	SubShader
	{
		Tags {"RenderType"="Transparent" "PerformanceChecks"="False" "IgnoreProjector" = "True" "PreviewType" = "Plane" "RenderPipeline" = "UniversalPipeline"}

		/////////////////////////////////////////////////////////////////////////////////////////////
		// FORWARD BASE
		/////////////////////////////////////////////////////////////////////////////////////////////
		Pass
		{
			Stencil
			{
				Ref [_StencilRef]
				ReadMask [_StencilReadMask]
				WriteMask [_StencilWriteMask]
				Comp [_StencilComp]
				Pass [_StencilPass]
				Fail [_StencilFail]
				ZFail [_StencilZFail]
			}

			Tags { "LightMode" = "UniversalForward" } 
			Name "ForwardBase" 
			Cull [_RenderFace]
			Blend [_BlendSrc] [_BlendDst]
			ZWrite [_ZWrite]
			ZTest [_ZTest]
			ColorMask RGB

			HLSLPROGRAM
			#pragma target 5.0
			#pragma shader_feature_local __ _MK_SOFT_FADE
			#pragma shader_feature_local __ _MK_CAMERA_FADE
			#pragma shader_feature_local __ _MK_COLOR_BLEND_ADDITIVE _MK_COLOR_BLEND_SUBTRACTIVE _MK_COLOR_BLEND_OVERLAY _MK_COLOR_BLEND_COLOR _MK_COLOR_BLEND_DIFFERENCE
			#pragma shader_feature_local __ _MK_SURFACE_TYPE_TRANSPARENT
			#pragma shader_feature_local __ _MK_ALPHA_CLIPPING
			#pragma shader_feature_local __ _MK_VERTEX_ANIMATION_STUTTER
			#pragma shader_feature_local __ _MK_VERTEX_ANIMATION_SINE _MK_VERTEX_ANIMATION_PULSE _MK_VERTEX_ANIMATION_NOISE
			#pragma shader_feature_local __ _MK_VERTEX_ANIMATION_MAP
			#pragma shader_feature_local __ _MK_DISSOLVE_DEFAULT _MK_DISSOLVE_BORDER_COLOR _MK_DISSOLVE_BORDER_RAMP
			#pragma shader_feature_local __ _MK_ALBEDO_MAP
            #pragma shader_feature_local __ _MK_BLEND_PREMULTIPLY _MK_BLEND_ADDITIVE _MK_BLEND_MULTIPLY
			#pragma shader_feature_local __ _MK_COLOR_GRADING_ALBEDO _MK_COLOR_GRADING_FINAL_OUTPUT
			#pragma shader_feature_local __ _MK_REFRACTION_DISTORTION_MAP
			#pragma shader_feature_local __ _MK_INDEX_OF_REFRACTION

			#pragma fragmentoption ARB_precision_hint_fastest
			#pragma vertex ForwardVert
			#pragma fragment ForwardFrag

			#pragma multi_compile_fog

			#pragma prefer_hlslcc gles
            #pragma exclude_renderers d3d11_9x

			#define MK_URP
			#define MK_REFRACTION
			#define MK_PARTICLES
			#define MK_UNLIT

			#include "../../Lib/Forward/BaseSetup.hlsl"
			
			ENDHLSL
		}
		
		/////////////////////////////////////////////////////////////////////////////////////////////
		// FORWARD ADD
		/////////////////////////////////////////////////////////////////////////////////////////////

		/////////////////////////////////////////////////////////////////////////////////////////////
		// DEFERRED
		/////////////////////////////////////////////////////////////////////////////////////////////

		/////////////////////////////////////////////////////////////////////////////////////////////
		// SHADOWCASTER
		/////////////////////////////////////////////////////////////////////////////////////////////

		/////////////////////////////////////////////////////////////////////////////////////////////
		// META
		/////////////////////////////////////////////////////////////////////////////////////////////

		/////////////////////////////////////////////////////////////////////////////////////////////
		// Depth Only
		/////////////////////////////////////////////////////////////////////////////////////////////
		//Not needed on particles
		
		/////////////////////////////////////////////////////////////////////////////////////////////
		// Universal2D
		/////////////////////////////////////////////////////////////////////////////////////////////
		Pass
        {
            Name "Universal2D"
            Tags{ "LightMode" = "Universal2D" }

            Blend [_BlendSrc] [_BlendDst]
            ZWrite [_ZWrite]
            Cull [_RenderFace]

            HLSLPROGRAM
            #pragma prefer_hlslcc gles
            #pragma exclude_renderers d3d11_9x
			#pragma target 5.0

            #pragma vertex Universal2DVert
            #pragma fragment Universal2DFrag
			
			#pragma shader_feature_local __ _MK_SURFACE_TYPE_TRANSPARENT
            #pragma shader_feature_local __ _MK_ALBEDO_MAP
			#pragma shader_feature_local __ _MK_ALPHA_CLIPPING
            #pragma shader_feature_local __ _MK_BLEND_PREMULTIPLY _MK_BLEND_ADDITIVE _MK_BLEND_MULTIPLY
			#pragma shader_feature_local __ _MK_VERTEX_ANIMATION_STUTTER
			#pragma shader_feature_local __ _MK_VERTEX_ANIMATION_SINE _MK_VERTEX_ANIMATION_PULSE _MK_VERTEX_ANIMATION_NOISE
			#pragma shader_feature_local __ _MK_VERTEX_ANIMATION_MAP
			#pragma shader_feature_local __ _MK_DISSOLVE_DEFAULT _MK_DISSOLVE_BORDER_COLOR _MK_DISSOLVE_BORDER_RAMP
			#pragma shader_feature_local __ _MK_COLOR_GRADING_ALBEDO _MK_COLOR_GRADING_FINAL_OUTPUT

            #define MK_URP
			#define MK_UNLIT
			#define MK_PARTICLES

            #include "../../Lib/Universal2D/Setup.hlsl"

            ENDHLSL
        }
    }
	
	/////////////////////////////////////////////////////////////////////////////////////////////
	// SM 3.5
	/////////////////////////////////////////////////////////////////////////////////////////////
	SubShader
	{
		Tags {"RenderType"="Transparent" "PerformanceChecks"="False" "IgnoreProjector" = "True" "PreviewType" = "Plane" "RenderPipeline" = "UniversalPipeline"}

		/////////////////////////////////////////////////////////////////////////////////////////////
		// FORWARD BASE
		/////////////////////////////////////////////////////////////////////////////////////////////
		Pass
		{
			Stencil
			{
				Ref [_StencilRef]
				ReadMask [_StencilReadMask]
				WriteMask [_StencilWriteMask]
				Comp [_StencilComp]
				Pass [_StencilPass]
				Fail [_StencilFail]
				ZFail [_StencilZFail]
			}

			Tags { "LightMode" = "UniversalForward" } 
			Name "ForwardBase" 
			Cull [_RenderFace]
			Blend [_BlendSrc] [_BlendDst]
			ZWrite [_ZWrite]
			ZTest [_ZTest]
			ColorMask RGB

			HLSLPROGRAM
			#pragma target 3.5
			#pragma shader_feature_local __ _MK_SOFT_FADE
			#pragma shader_feature_local __ _MK_CAMERA_FADE
			#pragma shader_feature_local __ _MK_COLOR_BLEND_ADDITIVE _MK_COLOR_BLEND_SUBTRACTIVE _MK_COLOR_BLEND_OVERLAY _MK_COLOR_BLEND_COLOR _MK_COLOR_BLEND_DIFFERENCE
			#pragma shader_feature_local __ _MK_SURFACE_TYPE_TRANSPARENT
			#pragma shader_feature_local __ _MK_ALPHA_CLIPPING
			#pragma shader_feature_local __ _MK_VERTEX_ANIMATION_STUTTER
			#pragma shader_feature_local __ _MK_VERTEX_ANIMATION_SINE _MK_VERTEX_ANIMATION_PULSE _MK_VERTEX_ANIMATION_NOISE
			#pragma shader_feature_local __ _MK_VERTEX_ANIMATION_MAP
			#pragma shader_feature_local __ _MK_DISSOLVE_DEFAULT _MK_DISSOLVE_BORDER_COLOR _MK_DISSOLVE_BORDER_RAMP
			#pragma shader_feature_local __ _MK_ALBEDO_MAP
            #pragma shader_feature_local __ _MK_BLEND_PREMULTIPLY _MK_BLEND_ADDITIVE _MK_BLEND_MULTIPLY
			#pragma shader_feature_local __ _MK_COLOR_GRADING_ALBEDO _MK_COLOR_GRADING_FINAL_OUTPUT
			#pragma shader_feature_local __ _MK_REFRACTION_DISTORTION_MAP
			#pragma shader_feature_local __ _MK_INDEX_OF_REFRACTION

			#pragma fragmentoption ARB_precision_hint_fastest
			#pragma vertex ForwardVert
			#pragma fragment ForwardFrag

			#pragma multi_compile_fog

			#pragma prefer_hlslcc gles
            #pragma exclude_renderers d3d11_9x

			#define MK_URP
			#define MK_REFRACTION
			#define MK_PARTICLES
			#define MK_UNLIT

			#include "../../Lib/Forward/BaseSetup.hlsl"
			
			ENDHLSL
		}
		
		/////////////////////////////////////////////////////////////////////////////////////////////
		// FORWARD ADD
		/////////////////////////////////////////////////////////////////////////////////////////////

		/////////////////////////////////////////////////////////////////////////////////////////////
		// DEFERRED
		/////////////////////////////////////////////////////////////////////////////////////////////

		/////////////////////////////////////////////////////////////////////////////////////////////
		// SHADOWCASTER
		/////////////////////////////////////////////////////////////////////////////////////////////

		/////////////////////////////////////////////////////////////////////////////////////////////
		// META
		/////////////////////////////////////////////////////////////////////////////////////////////

		/////////////////////////////////////////////////////////////////////////////////////////////
		// Depth Only
		/////////////////////////////////////////////////////////////////////////////////////////////
		//Not needed on particles
		
		/////////////////////////////////////////////////////////////////////////////////////////////
		// Universal2D
		/////////////////////////////////////////////////////////////////////////////////////////////
		Pass
        {
            Name "Universal2D"
            Tags{ "LightMode" = "Universal2D" }

            Blend [_BlendSrc] [_BlendDst]
            ZWrite [_ZWrite]
            Cull [_RenderFace]

            HLSLPROGRAM
            #pragma prefer_hlslcc gles
            #pragma exclude_renderers d3d11_9x
			#pragma target 3.5

            #pragma vertex Universal2DVert
            #pragma fragment Universal2DFrag
			
			#pragma shader_feature_local __ _MK_SURFACE_TYPE_TRANSPARENT
            #pragma shader_feature_local __ _MK_ALBEDO_MAP
			#pragma shader_feature_local __ _MK_ALPHA_CLIPPING
            #pragma shader_feature_local __ _MK_BLEND_PREMULTIPLY _MK_BLEND_ADDITIVE _MK_BLEND_MULTIPLY
			#pragma shader_feature_local __ _MK_VERTEX_ANIMATION_STUTTER
			#pragma shader_feature_local __ _MK_VERTEX_ANIMATION_SINE _MK_VERTEX_ANIMATION_PULSE _MK_VERTEX_ANIMATION_NOISE
			#pragma shader_feature_local __ _MK_VERTEX_ANIMATION_MAP
			#pragma shader_feature_local __ _MK_DISSOLVE_DEFAULT _MK_DISSOLVE_BORDER_COLOR _MK_DISSOLVE_BORDER_RAMP
			#pragma shader_feature_local __ _MK_COLOR_GRADING_ALBEDO _MK_COLOR_GRADING_FINAL_OUTPUT

            #define MK_URP
			#define MK_UNLIT
			#define MK_PARTICLES

            #include "../../Lib/Universal2D/Setup.hlsl"

            ENDHLSL
        }
    }

	/////////////////////////////////////////////////////////////////////////////////////////////
	// SM 3.0
	/////////////////////////////////////////////////////////////////////////////////////////////
	SubShader
	{
		Tags {"RenderType"="Transparent" "PerformanceChecks"="False" "IgnoreProjector" = "True" "PreviewType" = "Plane" "RenderPipeline" = "UniversalPipeline"}

		/////////////////////////////////////////////////////////////////////////////////////////////
		// FORWARD BASE
		/////////////////////////////////////////////////////////////////////////////////////////////
		Pass
		{
			Stencil
			{
				Ref [_StencilRef]
				ReadMask [_StencilReadMask]
				WriteMask [_StencilWriteMask]
				Comp [_StencilComp]
				Pass [_StencilPass]
				Fail [_StencilFail]
				ZFail [_StencilZFail]
			}

			Tags { "LightMode" = "UniversalForward" } 
			Name "ForwardBase" 
			Cull [_RenderFace]
			Blend [_BlendSrc] [_BlendDst]
			ZWrite [_ZWrite]
			ZTest [_ZTest]
			ColorMask RGB

			HLSLPROGRAM
			#pragma target 3.0
			#pragma shader_feature_local __ _MK_SOFT_FADE
			#pragma shader_feature_local __ _MK_CAMERA_FADE
			#pragma shader_feature_local __ _MK_COLOR_BLEND_ADDITIVE _MK_COLOR_BLEND_SUBTRACTIVE _MK_COLOR_BLEND_OVERLAY _MK_COLOR_BLEND_COLOR _MK_COLOR_BLEND_DIFFERENCE
			#pragma shader_feature_local __ _MK_SURFACE_TYPE_TRANSPARENT
			#pragma shader_feature_local __ _MK_ALPHA_CLIPPING
			#pragma shader_feature_local __ _MK_VERTEX_ANIMATION_STUTTER
			#pragma shader_feature_local __ _MK_VERTEX_ANIMATION_SINE _MK_VERTEX_ANIMATION_PULSE _MK_VERTEX_ANIMATION_NOISE
			#pragma shader_feature_local __ _MK_VERTEX_ANIMATION_MAP
			#pragma shader_feature_local __ _MK_DISSOLVE_DEFAULT _MK_DISSOLVE_BORDER_COLOR _MK_DISSOLVE_BORDER_RAMP
			#pragma shader_feature_local __ _MK_ALBEDO_MAP
            #pragma shader_feature_local __ _MK_BLEND_PREMULTIPLY _MK_BLEND_ADDITIVE _MK_BLEND_MULTIPLY
			#pragma shader_feature_local __ _MK_COLOR_GRADING_ALBEDO _MK_COLOR_GRADING_FINAL_OUTPUT
			#pragma shader_feature_local __ _MK_REFRACTION_DISTORTION_MAP
			#pragma shader_feature_local __ _MK_INDEX_OF_REFRACTION

			#pragma fragmentoption ARB_precision_hint_fastest
			#pragma vertex ForwardVert
			#pragma fragment ForwardFrag

			#pragma multi_compile_fog

			#pragma prefer_hlslcc gles
            #pragma exclude_renderers d3d11_9x

			#define MK_URP
			#define MK_REFRACTION
			#define MK_PARTICLES
			#define MK_UNLIT

			#include "../../Lib/Forward/BaseSetup.hlsl"
			
			ENDHLSL
		}
		
		/////////////////////////////////////////////////////////////////////////////////////////////
		// FORWARD ADD
		/////////////////////////////////////////////////////////////////////////////////////////////

		/////////////////////////////////////////////////////////////////////////////////////////////
		// DEFERRED
		/////////////////////////////////////////////////////////////////////////////////////////////

		/////////////////////////////////////////////////////////////////////////////////////////////
		// SHADOWCASTER
		/////////////////////////////////////////////////////////////////////////////////////////////

		/////////////////////////////////////////////////////////////////////////////////////////////
		// META
		/////////////////////////////////////////////////////////////////////////////////////////////

		/////////////////////////////////////////////////////////////////////////////////////////////
		// Depth Only
		/////////////////////////////////////////////////////////////////////////////////////////////
		//Not needed on particles
		
		/////////////////////////////////////////////////////////////////////////////////////////////
		// Universal2D
		/////////////////////////////////////////////////////////////////////////////////////////////
		Pass
        {
            Name "Universal2D"
            Tags{ "LightMode" = "Universal2D" }

            Blend [_BlendSrc] [_BlendDst]
            ZWrite [_ZWrite]
            Cull [_RenderFace]

            HLSLPROGRAM
            #pragma prefer_hlslcc gles
            #pragma exclude_renderers d3d11_9x
			#pragma target 3.0

            #pragma vertex Universal2DVert
            #pragma fragment Universal2DFrag
			
			#pragma shader_feature_local __ _MK_SURFACE_TYPE_TRANSPARENT
            #pragma shader_feature_local __ _MK_ALBEDO_MAP
			#pragma shader_feature_local __ _MK_ALPHA_CLIPPING
            #pragma shader_feature_local __ _MK_BLEND_PREMULTIPLY _MK_BLEND_ADDITIVE _MK_BLEND_MULTIPLY
			#pragma shader_feature_local __ _MK_VERTEX_ANIMATION_STUTTER
			#pragma shader_feature_local __ _MK_VERTEX_ANIMATION_SINE _MK_VERTEX_ANIMATION_PULSE _MK_VERTEX_ANIMATION_NOISE
			#pragma shader_feature_local __ _MK_VERTEX_ANIMATION_MAP
			#pragma shader_feature_local __ _MK_DISSOLVE_DEFAULT _MK_DISSOLVE_BORDER_COLOR _MK_DISSOLVE_BORDER_RAMP
			#pragma shader_feature_local __ _MK_COLOR_GRADING_ALBEDO _MK_COLOR_GRADING_FINAL_OUTPUT

            #define MK_URP
			#define MK_UNLIT
			#define MK_PARTICLES

            #include "../../Lib/Universal2D/Setup.hlsl"

            ENDHLSL
        }
    }

	/////////////////////////////////////////////////////////////////////////////////////////////
	// SM 2.5
	/////////////////////////////////////////////////////////////////////////////////////////////
	SubShader
	{
		Tags {"RenderType"="Transparent" "PerformanceChecks"="False" "IgnoreProjector" = "True" "PreviewType" = "Plane" "RenderPipeline" = "UniversalPipeline"}

		/////////////////////////////////////////////////////////////////////////////////////////////
		// FORWARD BASE
		/////////////////////////////////////////////////////////////////////////////////////////////
		Pass
		{
			Stencil
			{
				Ref [_StencilRef]
				ReadMask [_StencilReadMask]
				WriteMask [_StencilWriteMask]
				Comp [_StencilComp]
				Pass [_StencilPass]
				Fail [_StencilFail]
				ZFail [_StencilZFail]
			}

			Tags { "LightMode" = "UniversalForward" } 
			Name "ForwardBase" 
			Cull [_RenderFace]
			Blend [_BlendSrc] [_BlendDst]
			ZWrite [_ZWrite]
			ZTest [_ZTest]
			ColorMask RGB

			HLSLPROGRAM
			#pragma target 2.5
			#pragma shader_feature_local __ _MK_SOFT_FADE
			#pragma shader_feature_local __ _MK_CAMERA_FADE
			#pragma shader_feature_local __ _MK_COLOR_BLEND_ADDITIVE _MK_COLOR_BLEND_SUBTRACTIVE _MK_COLOR_BLEND_OVERLAY _MK_COLOR_BLEND_COLOR _MK_COLOR_BLEND_DIFFERENCE
			#pragma shader_feature_local __ _MK_SURFACE_TYPE_TRANSPARENT
			#pragma shader_feature_local __ _MK_ALPHA_CLIPPING
			#pragma shader_feature_local __ _MK_VERTEX_ANIMATION_STUTTER
			#pragma shader_feature_local __ _MK_VERTEX_ANIMATION_SINE _MK_VERTEX_ANIMATION_PULSE _MK_VERTEX_ANIMATION_NOISE
			#pragma shader_feature_local __ _MK_DISSOLVE_DEFAULT _MK_DISSOLVE_BORDER_COLOR _MK_DISSOLVE_BORDER_RAMP
			#pragma shader_feature_local __ _MK_ALBEDO_MAP
            #pragma shader_feature_local __ _MK_BLEND_PREMULTIPLY _MK_BLEND_ADDITIVE _MK_BLEND_MULTIPLY
			#pragma shader_feature_local __ _MK_COLOR_GRADING_ALBEDO _MK_COLOR_GRADING_FINAL_OUTPUT
			#pragma shader_feature_local __ _MK_REFRACTION_DISTORTION_MAP
			#pragma shader_feature_local __ _MK_INDEX_OF_REFRACTION

			#pragma fragmentoption ARB_precision_hint_fastest
			#pragma vertex ForwardVert
			#pragma fragment ForwardFrag

			#pragma multi_compile_fog

			#pragma prefer_hlslcc gles
            #pragma exclude_renderers d3d11_9x

			#define MK_URP
			#define MK_REFRACTION
			#define MK_PARTICLES
			#define MK_UNLIT

			#include "../../Lib/Forward/BaseSetup.hlsl"
			
			ENDHLSL
		}
		
		/////////////////////////////////////////////////////////////////////////////////////////////
		// FORWARD ADD
		/////////////////////////////////////////////////////////////////////////////////////////////

		/////////////////////////////////////////////////////////////////////////////////////////////
		// DEFERRED
		/////////////////////////////////////////////////////////////////////////////////////////////

		/////////////////////////////////////////////////////////////////////////////////////////////
		// SHADOWCASTER
		/////////////////////////////////////////////////////////////////////////////////////////////

		/////////////////////////////////////////////////////////////////////////////////////////////
		// META
		/////////////////////////////////////////////////////////////////////////////////////////////

		/////////////////////////////////////////////////////////////////////////////////////////////
		// Depth Only
		/////////////////////////////////////////////////////////////////////////////////////////////
		//Not needed on particles
		
		/////////////////////////////////////////////////////////////////////////////////////////////
		// Universal2D
		/////////////////////////////////////////////////////////////////////////////////////////////
		Pass
        {
            Name "Universal2D"
            Tags{ "LightMode" = "Universal2D" }

            Blend [_BlendSrc] [_BlendDst]
            ZWrite [_ZWrite]
            Cull [_RenderFace]

            HLSLPROGRAM
            #pragma prefer_hlslcc gles
            #pragma exclude_renderers d3d11_9x
			#pragma target 2.5

            #pragma vertex Universal2DVert
            #pragma fragment Universal2DFrag
			
			#pragma shader_feature_local __ _MK_SURFACE_TYPE_TRANSPARENT
            #pragma shader_feature_local __ _MK_ALBEDO_MAP
			#pragma shader_feature_local __ _MK_ALPHA_CLIPPING
            #pragma shader_feature_local __ _MK_BLEND_PREMULTIPLY _MK_BLEND_ADDITIVE _MK_BLEND_MULTIPLY
			#pragma shader_feature_local __ _MK_VERTEX_ANIMATION_STUTTER
			#pragma shader_feature_local __ _MK_VERTEX_ANIMATION_SINE _MK_VERTEX_ANIMATION_PULSE _MK_VERTEX_ANIMATION_NOISE
			#pragma shader_feature_local __ _MK_DISSOLVE_DEFAULT _MK_DISSOLVE_BORDER_COLOR _MK_DISSOLVE_BORDER_RAMP
			#pragma shader_feature_local __ _MK_COLOR_GRADING_ALBEDO _MK_COLOR_GRADING_FINAL_OUTPUT

            #define MK_URP
			#define MK_UNLIT
			#define MK_PARTICLES

            #include "../../Lib/Universal2D/Setup.hlsl"

            ENDHLSL
        }
    }
	
	FallBack Off
	CustomEditor "MK.Toon.Editor.URP.ParticlesUnlitEditor"
}
