


%define %statsmaps(Type)
%typemap(in, numinputs=0) Type *out_stats (Type *temp) {
    temp = (Type *)calloc(1, sizeof(Type));
    $1 = temp;
}
%typemap(argout) Type *out_stats {
    %append_output(SWIG_NewPointerObj(SWIG_as_voidptr(temp$argnum), $1_descriptor, 0));
}
%enddef


%rename (NodeStats) SM_NodeStats;
%statsmaps(SM_NodeStats);
%apply SM_NodeStats *out_stats {
    SM_NodeStats *nodeStats
}


%rename (StorageStats) SM_StorageStats;
%statsmaps(SM_StorageStats);
%apply SM_StorageStats *out_stats {
    SM_StorageStats *storageStats
}


%rename (OutfallStats) SM_OutfallStats;
/* PROVIDE CUSTOM CONSTRUCTOR/DECONSTRUCTOR */
%nodefaultctor SM_OutfallStats;

%extend SM_OutfallStats {
    SM_OutfallStats(int num_pollut) {
        SM_OutfallStats *s = (SM_OutfallStats *)calloc(1, sizeof(SM_OutfallStats));
        if (num_pollut > 0)
            s->totalLoad = (double *)calloc(num_pollut, sizeof(double));
        return s;
    }

    ~SM_OutfallStats(SM_OutfallStats *self) {
        if (self != NULL)
            free(self->totalLoad);
        free(self);
    }

    double get_totalLoad(int index) {
        return self->totalLoad[index];
    }
}

%typemap(in, numinputs=0) SM_OutfallStats *out_outfall_stats (SM_OutfallStats *temp) {
    int num_pollut;
    swmm_countObjects(SM_POLLUT, &num_pollut);
    temp = new_SM_OutfallStats(num_pollut);
    $1 = temp;
}
%typemap(argout) SM_OutfallStats *out_outfall_stats {
    %append_output(SWIG_NewPointerObj(SWIG_as_voidptr(temp$argnum), $1_descriptor, 0));
}

%apply SM_OutfallStats *out_outfall_stats {
    SM_OutfallStats *outfallStats
}


%rename (LinkStats) SM_LinkStats;
%statsmaps(SM_LinkStats);
%apply SM_LinkStats *out_stats {
    SM_LinkStats *linkStats
}


%rename (PumpStats) SM_PumpStats;
%statsmaps(SM_PumpStats);
%apply SM_PumpStats *out_stats {
    SM_PumpStats *pumpStats
}


%rename (SubcatchStats) SM_SubcatchStats;
%statsmaps(SM_SubcatchStats);
%apply SM_SubcatchStats *out_stats {
    SM_SubcatchStats *subcatchStats
}


%rename (RoutingTotals) SM_RoutingTotals;
%statsmaps(SM_RoutingTotals);
%apply SM_RoutingTotals *out_stats {
    SM_RoutingTotals *routingTotals
}


%rename (RunoffTotals) SM_RunoffTotals;
%statsmaps(SM_RunoffTotals);
%apply SM_RunoffTotals *out_stats {
    SM_RunoffTotals *runoffTotals
}


/* WRAP PUBLIC STRUCTURES AND GENERATE GETTERS */
%immutable;
%include "toolkit_structs.h"
%noimmutable;
