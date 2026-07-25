#include "..\byondapi.h"
#include "..\byondapi_cpp_wrappers.h"

/*
	How to call this library in BYOND:

	world << call_ext("byondapi_sample", "byond:AddNumbers")(1, 2, 3)
 */

// This version of AddNumbers uses the C++ wrappers.
// The array argument can use the ByondValue wrapper class, but the return
// value has to use the C struct.
extern "C" BYOND_EXPORT CByondValue AddNumbers(u4c n, ByondValue v[]) {
	float total = 0.0f;
	for(u4c i=0; i<n; ++i) {
		if(v[i].IsNum()) total += v[i].GetNum();
	}
	// The caller cleans up this value; call Detach() so the wrapper doesn't do it.
	// The detached CByondValue is returned, which we send back to the caller.
	return ByondValue(total).Detach();
}

/*

Strictly C version without wrappers:

extern "C" BYOND_EXPORT CByondValue AddNumbers(u4c n, CByondValue v[]) {
	CByondValue ret;
	float total = 0.0f;
	for(u4c i=0; i<n; ++i) {
		if(ByondValue_IsNum(v[i])) total += ByondValue_GetNum(v[i]);
	}
	ByondValue_InitNum(&ret, total);
	return ret;
}

*/
