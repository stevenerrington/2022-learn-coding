import numpy as np


def get_stop_basics(data):
        
    ssd_list = np.unique(data['ssd'])
    ssd_list = ssd_list[ssd_list > 0]

    ssd = []; pnc = []; ntr = [];

    # For each SSD, find trials
    for x in range(1,len(ssd_list)):
        ssd_df = data.loc[data['ssd'] == ssd_list[x]]

        ssd.append(ssd_list[x])
        pnc.append(1 - np.mean(ssd_df['inhibited']))
        ntr.append(len(ssd_df))

    stopsig_out = (ssd,pnc,ntr);
    return stopsig_out


def find_nearest_rt(rt_cdf,rt_sorted,pnc_i):
    pnc_cdf_diff = np.abs(rt_cdf - pnc_i)
    pnc_cdf_simidx = pnc_cdf_diff.argmin()
    ssd_rt = rt_sorted[pnc_cdf_simidx]
    return ssd_rt


def get_ssrtIntWeight(stoppingBeh):

    ssd = stoppingBeh["ssd"]
    pnc = stoppingBeh["pnc"]
    ntr = stoppingBeh["ntr"]
    nostop_rt = stoppingBeh["nostop_rt"]
    
    n_ns_trls = len(nostop_rt)
    rt_sorted = np.sort(nostop_rt)
    rt_cdf = np.arange(n_ns_trls) / float(n_ns_trls)

    # Initialise lists
    ssrt_i = [];
    ssrt_weighted_i = [];

    # For each SSD
    for i in range(len(ssd)):
            ssd_i = ssd[i] # Get SSD value (ms)
            pnc_i = pnc[i] # Get p(respond|SSD)
            ntr_i = ntr[i]/sum(ntr) # Proportion of stop-trials 

            ssd_rt = find_nearest_rt(rt_cdf,rt_sorted,pnc_i) # corresponding RT 
            
            ssrt_i.append(ssd_rt-ssd_i) # SSRT | SSD
            ssrt_weighted_i.append((ssd_rt-ssd_i)*ntr_i) # SSRT | Weighted SSD

    ssrt_weighted = sum(ssrt_weighted_i) # Sum up all the weighted SSD's to get the weighted average

    return ssrt_weighted